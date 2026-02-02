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

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.penaltyMode = PenaltyMode.standard,
    this.streak = 0,
    this.lastValidatedDate,
    Map<String, DayStatus>? history,
  }) : history = history ?? {};

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isQuitting': isQuitting,
    'penaltyMode': penaltyMode.index,
    'streak': streak,
    'lastValidatedDate': lastValidatedDate?.toIso8601String(),
    'history': history.map((key, value) => MapEntry(key, value.index)),
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
  );
}
