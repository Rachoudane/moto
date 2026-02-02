import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../screens/habit_detail_screen.dart';
import 'habit_progress.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  static const Color cardBg = Color(0xFF161B22);
  static const Color accentGreen = Color(0xFF7DD3A8);
  static const Color danger = Color(0xFFF85149);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);

  const HabitCard({
    super.key,
    required this.habit,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    required this.onUpdate,
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
            backgroundColor: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Supprimer cette habitude ?',
              style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Tu vas perdre ta progression de ${habit.streak} cases.',
              style: GoogleFonts.inter(color: textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Annuler', style: GoogleFonts.inter(color: textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Supprimer',
                  style: GoogleFonts.inter(color: danger, fontWeight: FontWeight.w600),
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
          color: danger.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(
                habit: habit,
                onUpdate: onUpdate,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF30363D).withValues(alpha: 0.5),
            ),
          ),
          child: Column(
          children: [
            // Top: name + progress
            Row(
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                HabitProgress(streak: habit.streak),
              ],
            ),
            const SizedBox(height: 8),
            // Subtitle: streak + mode + stop
            Row(
              children: [
                Text(
                  '${habit.streak} cases',
                  style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
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
                      color: danger.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: danger.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'STOP',
                      style: GoogleFonts.inter(fontSize: 9, color: danger, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: habit.isValidatedToday ? 0.4 : 1.0,
                    child: Material(
                      color: danger.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: habit.isValidatedToday ? null : onDecrement,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Center(
                            child: Text(
                              habit.isValidatedToday ? '✓' : 'Passé',
                              style: GoogleFonts.inter(
                                color: habit.isValidatedToday ? textSecondary : danger,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: habit.isValidatedToday ? 0.4 : 1.0,
                    child: Material(
                      color: accentGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: habit.isValidatedToday ? null : onIncrement,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Center(
                            child: Text(
                              habit.isValidatedToday ? '✓' : 'Fait',
                              style: GoogleFonts.inter(
                                color: habit.isValidatedToday ? textSecondary : accentGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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
