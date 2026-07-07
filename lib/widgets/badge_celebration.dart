import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../services/badge_service.dart';
import '../services/share_service.dart';
import 'badge_medallion.dart';
import 'celebration_dialog.dart';
import 'moto_san.dart';

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

  await showCelebrationDialog(
    context: context,
    contentBuilder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MotoSan(pose: MotoSanPose.celebrate, height: 100),
        const SizedBox(height: 16),
        BadgeMedallion(
          icon: badgeIcons[type]!,
          tier: tier,
          family: family,
          size: 76,
          animateIn: true,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
        // Primary action styled like every other primary button in the
        // app (filled accentGreen pill), instead of a plain text link.
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
            style: GoogleFonts.inter(color: theme.textSecondary, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
