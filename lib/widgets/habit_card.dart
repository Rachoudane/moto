import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/habit.dart';
import '../screens/habit_detail_screen.dart';
import 'habit_progress.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

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
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final (progress, total) = _getCurrentProgress();
    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: theme.cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              l10n.deleteHabit,
              style: GoogleFonts.inter(color: theme.textPrimary, fontWeight: FontWeight.w600),
            ),
            content: Text(
              l10n.deleteHabitConfirm(habit.streak),
              style: GoogleFonts.inter(color: theme.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel, style: GoogleFonts.inter(color: theme.textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  l10n.delete,
                  style: GoogleFonts.inter(color: theme.danger, fontWeight: FontWeight.w600),
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
          color: theme.danger.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailScreen(
                habit: habit,
                onUpdate: onUpdate,
              ),
            ),
          );
          onUpdate();
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderColor),
          ),
          child: Column(
            children: [
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
                            color: theme.textPrimary,
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
                                color: theme.textSecondary,
                              ),
                            ),
                            if (habit.isQuitting) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: theme.danger.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  l10n.stop,
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    color: theme.danger.withValues(alpha: 0.7),
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
              if (habit.isValidatedToday)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      l10n.validated,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: theme.textSecondary.withValues(alpha: 0.5),
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
                              border: Border.all(color: theme.textSecondary.withValues(alpha: 0.3)),
                            ),
                            child: Center(
                              child: Text(
                                l10n.skipped,
                                style: GoogleFonts.inter(
                                  color: theme.textSecondary,
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
                              border: Border.all(color: theme.accentGreen.withValues(alpha: 0.5)),
                            ),
                            child: Center(
                              child: Text(
                                l10n.done,
                                style: GoogleFonts.inter(
                                  color: theme.accentGreen,
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
