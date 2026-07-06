import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_badge.dart';
import '../models/habit.dart';

class BadgeService {
  static const String _key = 'unlocked_badges';

  // Serializes checkAndUnlock calls so overlapping invocations (e.g. a
  // validation tap and a background missed-days recalculation) can't
  // interleave their read-modify-write of the persisted badge list and
  // silently drop each other's newly-unlocked badges.
  static Future<void> _queue = Future.value();

  static int _completedSquares(Habit habit) {
    int level = 1;
    int total = 0;
    while (total + level * level <= habit.streak) {
      total += level * level;
      level++;
    }
    return level - 1;
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

    final longestStreakEver = habits.isEmpty
        ? 0
        : habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
    unlock(BadgeType.streak7, longestStreakEver >= 7);
    unlock(BadgeType.streak30, longestStreakEver >= 30);
    unlock(BadgeType.streak100, longestStreakEver >= 100);
    unlock(BadgeType.streak365, longestStreakEver >= 365);

    final maxCompletedSquares = habits.isEmpty
        ? 0
        : habits.map(_completedSquares).reduce((a, b) => a > b ? a : b);
    unlock(BadgeType.square1, maxCompletedSquares >= 1);
    unlock(BadgeType.square2, maxCompletedSquares >= 2);
    unlock(BadgeType.square3, maxCompletedSquares >= 3);
    unlock(BadgeType.square5, maxCompletedSquares >= 5);
    unlock(BadgeType.square8, maxCompletedSquares >= 8);

    final totalCellsEver =
        habits.fold<int>(0, (sum, h) => sum + h.totalValidatedDays);
    unlock(BadgeType.cells10, totalCellsEver >= 10);
    unlock(BadgeType.cells50, totalCellsEver >= 50);
    unlock(BadgeType.cells100, totalCellsEver >= 100);
    unlock(BadgeType.cells500, totalCellsEver >= 500);
    unlock(BadgeType.cells1000, totalCellsEver >= 1000);

    unlock(BadgeType.habits3, habits.length >= 3);
    unlock(BadgeType.habits5, habits.length >= 5);
    unlock(BadgeType.habits10, habits.length >= 10);

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
      final date = todayNorm.subtract(Duration(days: i));
      if (habit.getStatusForDate(date) != DayStatus.validated) return false;
    }
    return true;
  }

  static bool _hasWeekendWarrior(Habit habit) {
    final today = DateTime.now();
    var sunday = DateTime(today.year, today.month, today.day);
    while (sunday.weekday != DateTime.sunday) {
      sunday = sunday.subtract(const Duration(days: 1));
    }
    final saturday = sunday.subtract(const Duration(days: 1));
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
