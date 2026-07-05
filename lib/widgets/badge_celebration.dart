import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../services/badge_service.dart';
import '../services/share_service.dart';

/// Shows the badge-unlocked celebration dialog for [type]. Safe to call from
/// any screen; awaits so callers can chain multiple unlocks sequentially
/// (e.g. several badges crossed at once via a bulk history edit) without
/// them overlapping.
Future<void> showBadgeCelebration(BuildContext context, BadgeType type) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context).extension<MotoTheme>()!;
  const amber = Color(0xFFE5C07B);
  final unlocked = (await BadgeService.getUnlocked())
      .firstWhere((b) => b.type == type);

  if (!context.mounted) return;

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'badge',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, anim1, anim2) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: amber.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: amber.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(badgeIcons[type], color: amber, size: 48)
                  .animate()
                  .scale(
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.3, 0.3),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(height: 16),
              Text(
                l10n.badgeUnlockedTitle,
                style: GoogleFonts.inter(
                  color: amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ShareService.badgeName(type, l10n),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                ShareService.badgeDescription(type, l10n),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: theme.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ShareService.shareBadge(unlocked, l10n);
                    },
                    child: Text(
                      l10n.shareApp,
                      style: GoogleFonts.inter(color: theme.accentGreen),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: GoogleFonts.inter(color: theme.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 250.ms).scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              duration: 250.ms,
            ),
      );
    },
  );
}
