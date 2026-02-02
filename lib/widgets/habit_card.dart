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
  static const Color borderColor = Color(0xFF21262D);

  const HabitCard({
    super.key,
    required this.habit,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    required this.onUpdate,
  });

  (int, int) _getCurrentProgress() {
    int level = 1;
    int remaining = habit.streak;
    while (remaining >= level * level) {
      remaining -= level * level;
      level++;
    }
    return (remaining, level * level);
  }

  @override
  Widget build(BuildContext context) {
    final (progress, total) = _getCurrentProgress();

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
          borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              // Top: name + progress squares
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '$progress/$total',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                            if (habit.isQuitting) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: danger.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  'STOP',
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    color: danger.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  HabitProgress(streak: habit.streak),
                ],
              ),
              const SizedBox(height: 14),
              // Buttons or validated state
              if (habit.isValidatedToday)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      '✓',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: textSecondary.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: onDecrement,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: textSecondary.withValues(alpha: 0.3)),
                            ),
                            child: Center(
                              child: Text(
                                'Passé',
                                style: GoogleFonts.inter(
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: onIncrement,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: accentGreen.withValues(alpha: 0.5)),
                            ),
                            child: Center(
                              child: Text(
                                'Fait',
                                style: GoogleFonts.inter(
                                  color: accentGreen,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
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
