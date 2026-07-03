enum PenaltyMode {
  zen,      // Perd 1 case
  standard, // Perd le carré en cours
  hardcore, // Retour à zéro total
}

enum DayStatus {
  validated,
  skipped,
  pending,
}

/// All 7 weekdays, Monday(0) through Sunday(6). Used as the default
/// schedule so existing habits without a saved frequency behave as "daily".
const Set<int> allWeekdays = {0, 1, 2, 3, 4, 5, 6};

class Habit {
  final String id;
  String name;
  bool isQuitting;
  PenaltyMode penaltyMode;
  int streak;
  DateTime? lastValidatedDate;
  DateTime createdAt;
  Map<String, DayStatus> history;
  bool reminderEnabled;
  int? reminderHour;
  int? reminderMinute;
  // Weekdays this habit is scheduled on: 0 = Monday ... 6 = Sunday.
  // All 7 days selected means "every day".
  Set<int> scheduledWeekdays;

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.penaltyMode = PenaltyMode.standard,
    this.streak = 0,
    this.lastValidatedDate,
    DateTime? createdAt,
    Map<String, DayStatus>? history,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
    Set<int>? scheduledWeekdays,
  }) : createdAt = createdAt ?? DateTime.now(),
       history = history ?? {},
       scheduledWeekdays = scheduledWeekdays ?? {...allWeekdays};

  bool get isDailyFrequency => scheduledWeekdays.length >= 7;

  bool isScheduledDay(DateTime date) =>
      scheduledWeekdays.contains(date.weekday - 1);

  bool get isScheduledToday => isScheduledDay(DateTime.now());

  bool get isValidatedToday {
    if (lastValidatedDate == null) return false;
    final now = DateTime.now();
    return lastValidatedDate!.year == now.year &&
        lastValidatedDate!.month == now.month &&
        lastValidatedDate!.day == now.day;
  }

  int get daysMissed {
    if (lastValidatedDate == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      lastValidatedDate!.year,
      lastValidatedDate!.month,
      lastValidatedDate!.day,
    );
    return today.difference(lastDate).inDays - 1;
  }

  static String _dateToKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  DayStatus getStatusForDate(DateTime date) {
    final key = _dateToKey(date);
    return history[key] ?? DayStatus.pending;
  }

  void setStatusForDate(DateTime date, DayStatus status) {
    final key = _dateToKey(date);
    history[key] = status;
  }

  // Calculate success rate (percentage)
  double get successRate {
    if (history.isEmpty) return 0.0;
    final validated = history.values.where((s) => s == DayStatus.validated).length;
    return (validated / history.length) * 100;
  }

  // Get current streak (consecutive scheduled days validated, ending today or
  // yesterday). Days the habit isn't scheduled on are skipped over rather
  // than breaking the streak, so a 3x/week habit isn't punished for its
  // rest days.
  int get currentStreak {
    int streak = 0;
    var date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);
    final createdNorm = DateTime(createdAt.year, createdAt.month, createdAt.day);

    // If not validated today, start from yesterday
    if (!isScheduledDay(date) || getStatusForDate(date) != DayStatus.validated) {
      date = date.subtract(const Duration(days: 1));
    }

    while (!date.isBefore(createdNorm)) {
      if (!isScheduledDay(date)) {
        date = date.subtract(const Duration(days: 1));
        continue;
      }
      if (getStatusForDate(date) != DayStatus.validated) break;
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // Get longest streak ever
  int get longestStreak {
    if (history.isEmpty) return 0;
    
    int longest = 0;
    int current = 0;
    
    // Sort dates
    final sortedDates = history.keys.toList()..sort();
    
    for (final dateKey in sortedDates) {
      if (history[dateKey] == DayStatus.validated) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 0;
      }
    }
    return longest;
  }

  // Get best day of week (0 = Monday, 6 = Sunday)
  int? get bestDayOfWeek {
    if (history.isEmpty) return null;
    
    final dayStats = <int, int>{};
    final dayTotal = <int, int>{};
    
    history.forEach((dateKey, status) {
      final parts = dateKey.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      final weekday = date.weekday - 1; // 0-6
      
      dayTotal[weekday] = (dayTotal[weekday] ?? 0) + 1;
      if (status == DayStatus.validated) {
        dayStats[weekday] = (dayStats[weekday] ?? 0) + 1;
      }
    });
    
    if (dayStats.isEmpty) return null;
    
    int bestDay = 0;
    double bestRate = 0;
    
    dayStats.forEach((day, validated) {
      final rate = validated / (dayTotal[day] ?? 1);
      if (rate > bestRate) {
        bestRate = rate;
        bestDay = day;
      }
    });
    
    return bestDay;
  }

  // Get total validated days
  int get totalValidatedDays {
    return history.values.where((s) => s == DayStatus.validated).length;
  }

  // Apply the penalty for a single missed day to a given streak value
  static int applyPenalty(PenaltyMode mode, int currentStreak) {
    switch (mode) {
      case PenaltyMode.zen:
        return currentStreak > 0 ? currentStreak - 1 : 0;
      case PenaltyMode.standard:
        int level = 1;
        int total = 0;
        while (total + level * level <= currentStreak) {
          total += level * level;
          level++;
        }
        return currentStreak > total ? total : currentStreak;
      case PenaltyMode.hardcore:
        return 0;
    }
  }

  // Replays the full history day-by-day from creation to today, recomputing
  // streak and lastValidatedDate from scratch. This is the single source of
  // truth for streak correction after any historical edit (today or past).
  void recalculateStreak() {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    var date = DateTime(createdAt.year, createdAt.month, createdAt.day);

    int newStreak = 0;
    DateTime? newLastValidated;

    while (!date.isAfter(todayNorm)) {
      final status = getStatusForDate(date);
      if (status == DayStatus.validated) {
        newStreak++;
        newLastValidated = date;
      } else if (status == DayStatus.skipped) {
        newStreak = applyPenalty(penaltyMode, newStreak);
      }
      date = date.add(const Duration(days: 1));
    }

    streak = newStreak;
    lastValidatedDate = newLastValidated;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isQuitting': isQuitting,
    'penaltyMode': penaltyMode.index,
    'streak': streak,
    'lastValidatedDate': lastValidatedDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'history': history.map((key, value) => MapEntry(key, value.index)),
    'reminderEnabled': reminderEnabled,
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
    'scheduledWeekdays': scheduledWeekdays.toList(),
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    name: json['name'],
    isQuitting: json['isQuitting'] ?? false,
    penaltyMode: PenaltyMode.values[json['penaltyMode'] ?? 1],
    streak: json['streak'] ?? 0,
    lastValidatedDate: json['lastValidatedDate'] != null
        ? DateTime.parse(json['lastValidatedDate'])
        : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    history: (json['history'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, DayStatus.values[value as int]),
    ) ?? {},
    reminderEnabled: json['reminderEnabled'] ?? false,
    reminderHour: json['reminderHour'],
    reminderMinute: json['reminderMinute'],
    scheduledWeekdays: (json['scheduledWeekdays'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toSet() ??
        {...allWeekdays},
  );
}
