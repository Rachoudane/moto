class Habit {
  final String id;
  final String name;
  final bool isQuitting;
  int streak;

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.streak = 0,
  });

  // Convertir en JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isQuitting': isQuitting,
    'streak': streak,
  };

  // Créer depuis JSON
  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    name: json['name'],
    isQuitting: json['isQuitting'] ?? false,
    streak: json['streak'] ?? 0,
  );
}