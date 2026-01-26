class Habit {
  final String id;
  final String name;
  final bool isQuitting; // true = arrêter qqch, false = faire qqch
  int streak;

  Habit({
    required this.id,
    required this.name,
    this.isQuitting = false,
    this.streak = 0,
  });
}