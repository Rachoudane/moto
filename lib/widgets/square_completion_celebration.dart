import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/habit.dart';
import '../services/share_service.dart';
import 'celebration_dialog.dart';
import 'moto_san.dart';

const _trophyAmber = Color(0xFFE5C07B);

/// Shows the square-completion celebration dialog for [habit] reaching a
/// [level]x[level] square. Mirrors showBadgeCelebration's shell/tone.
Future<void> showSquareCompletionCelebration(
  BuildContext context,
  Habit habit,
  int level,
) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context).extension<MotoTheme>()!;

  return showCelebrationDialog(
    context: context,
    contentBuilder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MotoSan(pose: MotoSanPose.celebrate, height: 100),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _trophyAmber.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: _trophyAmber,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.squareCompletedCelebration(level),
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: theme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              ShareService.shareSquareCompletion(habit, level, l10n);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: theme.accentGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  l10n.shareApp,
                  style: GoogleFonts.inter(
                    color: theme.bg,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: GoogleFonts.inter(color: theme.textSecondary, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
