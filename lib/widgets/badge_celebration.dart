import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../services/badge_service.dart';
import '../services/share_service.dart';
import 'badge_medallion.dart';

/// Shows the badge-unlocked celebration dialog for [type]. Safe to call from
/// any screen; awaits so callers can chain multiple unlocks sequentially
/// (e.g. several badges crossed at once via a bulk history edit) without
/// them overlapping.
Future<void> showBadgeCelebration(BuildContext context, BadgeType type) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context).extension<MotoTheme>()!;
  final tier = badgeTiers[type] ?? BadgeTier.special;
  final family = badgeFamilies[type];
  final glow = badgeTierGlow(tier, family);
  final ink = badgeTierInk(tier);
  // The "badge unlocked" chip sits on theme.cardBg (tinted with the tier's
  // glow), so unlike the medallion (always on its own fixed gradient) its
  // label needs to flip between the bright and the deep tone depending on
  // which card background it's rendered over.
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  final badgeLabelColor = isDarkTheme ? glow : ink;
  final unlocked = (await BadgeService.getUnlocked()).firstWhere(
    (b) => b.type == type,
  );

  if (!context.mounted) return;

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'badge',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, anim1, anim2) {
      // showGeneralDialog (unlike showDialog) doesn't wrap pageBuilder's
      // result in a Material ancestor, so every Text/Icon below would
      // render with Flutter's debug "no Material ancestor" indicator (a
      // yellow/black underline under all the text) without this.
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child:
              Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                    decoration: BoxDecoration(
                      color: theme.cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BadgeMedallion(
                          icon: badgeIcons[type]!,
                          tier: tier,
                          family: family,
                          size: 76,
                          animateIn: true,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: glow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.badgeUnlockedTitle,
                            style: GoogleFonts.inter(
                              color: badgeLabelColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          ShareService.badgeName(type, l10n),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: theme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
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
                        const SizedBox(height: 24),
                        // Primary action styled like every other primary
                        // button in the app (filled accentGreen pill),
                        // instead of a plain text link.
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              ShareService.shareBadge(unlocked, l10n);
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
                            style: GoogleFonts.inter(
                              color: theme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 250.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    duration: 250.ms,
                  ),
        ),
      );
    },
  );
}
