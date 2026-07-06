import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_badge.dart';
import '../models/habit.dart';

enum BadgeMetric { longestStreak, completedSquares, totalCells, habitCount }

/// Threshold criteria for badges whose progress is a plain count (as
/// opposed to the behavioral/secret badges below, which are pass/fail and
/// have no meaningful "X/Y" progress).
const Map<BadgeType, (BadgeMetric, int)> _countableCriteria = {
  BadgeType.streak7: (BadgeMetric.longestStreak, 7),
  BadgeType.streak30: (BadgeMetric.longestStreak, 30),
  BadgeType.streak100: (BadgeMetric.longestStreak, 100),
  BadgeType.streak365: (BadgeMetric.longestStreak, 365),
  BadgeType.square1: (BadgeMetric.completedSquares, 1),
  BadgeType.square2: (BadgeMetric.completedSquares, 2),
  BadgeType.square3: (BadgeMetric.completedSquares, 3),
  BadgeType.square5: (BadgeMetric.completedSquares, 5),
  BadgeType.square8: (BadgeMetric.completedSquares, 8),
  BadgeType.cells10: (BadgeMetric.totalCells, 10),
  BadgeType.cells50: (BadgeMetric.totalCells, 50),
  BadgeType.cells100: (BadgeMetric.totalCells, 100),
  BadgeType.cells500: (BadgeMetric.totalCells, 500),
  BadgeType.cells1000: (BadgeMetric.totalCells, 1000),
  BadgeType.habits3: (BadgeMetric.habitCount, 3),
  BadgeType.habits5: (BadgeMetric.habitCount, 5),
  BadgeType.habits10: (BadgeMetric.habitCount, 10),
};

class BadgeService {
  static const String _key = 'unlocked_badges';

  // Serializes checkAndUnlock calls so overlapping invocations (e.g. a
  // validation tap and a background missed-days recalculation) can't
  // interleave their read-modify-write of the persisted badge list and
  // silently drop each other's newly-unlocked badges.
  static Future<void> _queue = Future.value();

  /// The four scalar counts every "countable" badge family is measured
  /// against. Computed once and shared by checkAndUnlock and progressForAll
  /// so the two can never disagree on what counts as progress.
  static (
    int longestStreak,
    int completedSquares,
    int totalCells,
    int habitCount,
  )
  _metrics(List<Habit> habits) {
    final longestStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
    final completedSquares = habits.isEmpty
        ? 0
        : habits
              .map((h) => Habit.completedSquaresFor(h.streak))
              .reduce((a, b) => a > b ? a : b);
    final totalCells = habits.fold<int>(
      0,
      (sum, h) => sum + h.totalValidatedDays,
    );
    return (longestStreak, completedSquares, totalCells, habits.length);
  }

  static int _valueFor(BadgeMetric metric, (int, int, int, int) metrics) {
    final (longestStreak, completedSquares, totalCells, habitCount) = metrics;
    return switch (metric) {
      BadgeMetric.longestStreak => longestStreak,
      BadgeMetric.completedSquares => completedSquares,
      BadgeMetric.totalCells => totalCells,
      BadgeMetric.habitCount => habitCount,
    };
  }

  /// Progress toward every "countable" badge (streak/square/cell/habit-count
  /// families), for a progress ring on locked badges. Behavioral and secret
  /// badges aren't included: their criteria are pass/fail, not a count, so a
  /// numeric progress ring wouldn't mean anything for them.
  static Map<BadgeType, (int current, int target)> progressForAll(
    List<Habit> habits,
  ) {
    final metrics = _metrics(habits);
    return _countableCriteria.map((type, criteria) {
      final (metric, target) = criteria;
      final current = _valueFor(metric, metrics);
      return MapEntry(type, (current < target ? current : target, target));
    });
  }

  static Future<List<AppBadge>> getUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(AppBadge.fromJson).toList();
  }

  static Future<void> _saveUnlocked(List<AppBadge> badges) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(badges.map((b) => b.toJson()).toList()),
    );
  }

  /// Evaluates all badge criteria against the current [habits] state,
  /// persists any newly-crossed badges, and returns the newly-unlocked
  /// types (for celebration UI). Safe to call after every save — calls are
  /// queued so overlapping invocations can't clobber each other's writes.
  static Future<List<BadgeType>> checkAndUnlock(List<Habit> habits) {
    final result = _queue.then((_) => _checkAndUnlockLocked(habits));
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  static Future<List<BadgeType>> _checkAndUnlockLocked(
    List<Habit> habits,
  ) async {
    final unlocked = await getUnlocked();
    final unlockedTypes = unlocked.map((b) => b.type).toSet();
    final newly = <BadgeType>[];

    void unlock(BadgeType type, bool condition) {
      if (condition && !unlockedTypes.contains(type)) {
        newly.add(type);
        unlockedTypes.add(type);
      }
    }

    final metrics = _metrics(habits);
    for (final entry in _countableCriteria.entries) {
      final (metric, target) = entry.value;
      unlock(entry.key, _valueFor(metric, metrics) >= target);
    }

    final justValidated = habits.where((h) => h.isValidatedToday);
    unlock(
      BadgeType.earlyBird,
      justValidated.any(
        (h) => h.lastValidatedDate != null && h.lastValidatedDate!.hour < 7,
      ),
    );
    unlock(
      BadgeType.nightOwl,
      justValidated.any(
        (h) => h.lastValidatedDate != null && h.lastValidatedDate!.hour >= 22,
      ),
    );

    unlock(BadgeType.weekendWarrior, habits.any(_hasWeekendWarrior));
    unlock(BadgeType.comeback, habits.any(_hasComeback));
    unlock(BadgeType.perfectWeek, habits.any((h) => _perfectRun(h, 7)));
    unlock(BadgeType.perfectMonth, habits.any((h) => _perfectRun(h, 30)));

    unlock(
      BadgeType.hardcoreSurvivor,
      habits.any(
        (h) => h.penaltyMode == PenaltyMode.hardcore && h.streak >= 30,
      ),
    );
    unlock(
      BadgeType.zenMaster,
      habits.any(
        (h) => h.penaltyMode == PenaltyMode.zen && h.totalValidatedDays >= 100,
      ),
    );

    unlock(
      BadgeType.secretPerfectionist,
      habits.any((h) => h.totalValidatedDays >= 20 && h.successRate >= 100),
    );
    unlock(
      BadgeType.secretMultitasker,
      habits.where((h) => h.streak > 0).length >= 5,
    );

    if (newly.isNotEmpty) {
      final now = DateTime.now();
      final updated = [
        ...unlocked,
        ...newly.map((t) => AppBadge(type: t, unlockedAt: now)),
      ];
      await _saveUnlocked(updated);
    }

    return newly;
  }

  static bool _perfectRun(Habit habit, int days) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final createdNorm = DateTime(
      habit.createdAt.year,
      habit.createdAt.month,
      habit.createdAt.day,
    );
    final daysSinceCreation = todayNorm.difference(createdNorm).inDays;
    if (daysSinceCreation < days - 1) return false;

    for (int i = 0; i < days; i++) {
      final date = Habit.addDays(todayNorm, -i);
      if (habit.getStatusForDate(date) != DayStatus.validated) return false;
    }
    return true;
  }

  static bool _hasWeekendWarrior(Habit habit) {
    final today = DateTime.now();
    var sunday = DateTime(today.year, today.month, today.day);
    while (sunday.weekday != DateTime.sunday) {
      sunday = Habit.addDays(sunday, -1);
    }
    final saturday = Habit.addDays(sunday, -1);
    return habit.getStatusForDate(saturday) == DayStatus.validated &&
        habit.getStatusForDate(sunday) == DayStatus.validated;
  }

  static bool _hasComeback(Habit habit) {
    final sortedDates = habit.history.keys.toList()..sort();
    int missedStreak = 0;
    for (final key in sortedDates) {
      final status = habit.history[key];
      if (status == DayStatus.validated) {
        if (missedStreak >= 3) return true;
        missedStreak = 0;
      } else if (status == DayStatus.skipped) {
        missedStreak++;
      }
    }
    return false;
  }
}
