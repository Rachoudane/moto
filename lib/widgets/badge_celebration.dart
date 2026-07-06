import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/app_badge.dart';
import '../services/badge_service.dart';
import '../services/share_service.dart';

// The medallion is a fixed "physical medal" surface (like a real badge),
// not a themed one, so it uses its own fixed palette rather than
// theme.cardBg/textPrimary. _medallionInk is a deep warm brown chosen for
// contrast against the gold gradient in both light and dark app themes.
const _celebrationGold = Color(0xFFE5C07B);
const _celebrationGoldDeep = Color(0xFFCFA05C);
const _medallionInk = Color(0xFF3A2A12);

/// Shows the badge-unlocked celebration dialog for [type]. Safe to call from
/// any screen; awaits so callers can chain multiple unlocks sequentially
/// (e.g. several badges crossed at once via a bulk history edit) without
/// them overlapping.
Future<void> showBadgeCelebration(BuildContext context, BadgeType type) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context).extension<MotoTheme>()!;
  // The "badge unlocked" chip sits on theme.cardBg (gold-tinted), so unlike
  // the medallion (always on a fixed gold gradient) its label needs to flip
  // between a bright and a deep gold depending on the surface it's on.
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  final badgeLabelColor = isDarkTheme ? _celebrationGold : _medallionInk;
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
                        // Medallion: a contained gold glow behind a gradient
                        // circle, instead of an amber border/glow around the
                        // whole card.
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _celebrationGold.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 32,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 76,
                              height: 76,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _celebrationGold,
                                    _celebrationGoldDeep,
                                  ],
                                ),
                              ),
                              child: Icon(
                                badgeIcons[type],
                                color: _medallionInk,
                                size: 34,
                              ),
                            ).animate().scale(
                              duration: 500.ms,
                              curve: Curves.elasticOut,
                              begin: const Offset(0.3, 0.3),
                              end: const Offset(1, 1),
                            ),
                            // Glossy top-left highlight for a medal-like shine.
                            IgnorePointer(
                              child: Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.35),
                                      Colors.white.withValues(alpha: 0),
                                    ],
                                    stops: const [0.0, 0.6],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _celebrationGold.withValues(alpha: 0.15),
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
