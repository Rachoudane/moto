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

class Habit {
  final String id;
  String name;
  bool isQuitting;
  PenaltyMode penaltyMode;
  int streak;
  DateTime? lastValidatedDate;
  Map<String, DayStatus> history;
  Map<String, int> streakBeforeAction; // Streak avant chaque action (pour correction)
  bool reminderEnabled;
  int? reminderHour;
  int? reminderMinute;

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.penaltyMode = PenaltyMode.standard,
    this.streak = 0,
    this.lastValidatedDate,
    Map<String, DayStatus>? history,
    Map<String, int>? streakBeforeAction,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
  }) : history = history ?? {},
       streakBeforeAction = streakBeforeAction ?? {};

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

  // Stocke le streak avant une action pour permettre la correction
  void setStreakBeforeAction(DateTime date, int streakValue) {
    final key = _dateToKey(date);
    streakBeforeAction[key] = streakValue;
  }

  // Récupère le streak avant l'action pour une date donnée
  int? getStreakBeforeAction(DateTime date) {
    final key = _dateToKey(date);
    return streakBeforeAction[key];
  }

  // Calculate success rate (percentage)
  double get successRate {
    if (history.isEmpty) return 0.0;
    final validated = history.values.where((s) => s == DayStatus.validated).length;
    return (validated / history.length) * 100;
  }

  // Get current streak (consecutive validated days ending today or yesterday)
  int get currentStreak {
    int streak = 0;
    var date = DateTime.now();
    
    // If not validated today, start from yesterday
    if (getStatusForDate(date) != DayStatus.validated) {
      date = date.subtract(const Duration(days: 1));
    }
    
    while (getStatusForDate(date) == DayStatus.validated) {
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isQuitting': isQuitting,
    'penaltyMode': penaltyMode.index,
    'streak': streak,
    'lastValidatedDate': lastValidatedDate?.toIso8601String(),
    'history': history.map((key, value) => MapEntry(key, value.index)),
    'streakBeforeAction': streakBeforeAction,
    'reminderEnabled': reminderEnabled,
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
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
    history: (json['history'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, DayStatus.values[value as int]),
    ) ?? {},
    streakBeforeAction: (json['streakBeforeAction'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, value as int),
    ) ?? {},
    reminderEnabled: json['reminderEnabled'] ?? false,
    reminderHour: json['reminderHour'],
    reminderMinute: json['reminderMinute'],
  );
}
