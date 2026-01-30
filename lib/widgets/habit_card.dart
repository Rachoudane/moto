import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../screens/habit_detail_screen.dart';
import 'habit_progress.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  String _getModeEmoji(PenaltyMode mode) {
    switch (mode) {
      case PenaltyMode.zen:
        return '🌱';
      case PenaltyMode.standard:
        return '⚡';
      case PenaltyMode.hardcore:
        return '🔥';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            title: const Text(
              'Supprimer cette habitude ?',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Tu vas perdre ta progression de ${habit.streak} cases.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red[400]),
                ),
              ),
            ],
          ),
        ) ?? false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(habit: habit),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
          children: [
            // Top: name + progress
            Row(
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                HabitProgress(streak: habit.streak),
              ],
            ),
            const SizedBox(height: 6),
            // Subtitle: streak + mode + stop
            Row(
              children: [
                Text(
                  '${habit.streak} cases',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(width: 8),
                Text(
                  _getModeEmoji(habit.penaltyMode),
                  style: const TextStyle(fontSize: 12),
                ),
                if (habit.isQuitting) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red[900]?.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'STOP',
                      style: TextStyle(fontSize: 9, color: Colors.white70),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onDecrement,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red[900]?.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('Raté', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onIncrement,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('Fait !', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
