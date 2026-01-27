enum PenaltyMode {
  zen,      // Perd 1 case
  standard, // Perd le carré en cours
  hardcore, // Retour à zéro total
}

class Habit {
  final String id;
  final String name;
  final bool isQuitting;
  final PenaltyMode penaltyMode;
  int streak;

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.penaltyMode = PenaltyMode.standard,
    this.streak = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isQuitting': isQuitting,
    'penaltyMode': penaltyMode.index,
    'streak': streak,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    name: json['name'],
    isQuitting: json['isQuitting'] ?? false,
    penaltyMode: PenaltyMode.values[json['penaltyMode'] ?? 1],
    streak: json['streak'] ?? 0,
  );
}
