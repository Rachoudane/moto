enum PenaltyMode {
  zen,      // Perd 1 case
  standard, // Perd le carré en cours
  hardcore, // Retour à zéro total
}

class Habit {
  final String id;
  String name;
  bool isQuitting;
  PenaltyMode penaltyMode;
  int streak;
  DateTime? lastValidatedDate;

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.penaltyMode = PenaltyMode.standard,
    this.streak = 0,
    this.lastValidatedDate,
  });

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isQuitting': isQuitting,
    'penaltyMode': penaltyMode.index,
    'streak': streak,
    'lastValidatedDate': lastValidatedDate?.toIso8601String(),
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
  );
}
