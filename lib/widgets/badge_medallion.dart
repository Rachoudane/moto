import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/app_badge.dart';

class _TierPalette {
  final Color top;
  final Color bottom;
  final Color ink;
  const _TierPalette(this.top, this.bottom, this.ink);
}

// Metal gradients for each rank, from a light "highlight" tone to a deeper
// "shadow" tone, plus an ink color chosen for contrast against that metal
// (not the app theme — a medal's material doesn't change with light/dark
// mode).
const _tierPalettes = {
  BadgeTier.bronze: _TierPalette(
    Color(0xFFC98F5E),
    Color(0xFF9C6B3E),
    Color(0xFF3A2412),
  ),
  BadgeTier.silver: _TierPalette(
    Color(0xFFE7EBEF),
    Color(0xFFAEB4BD),
    Color(0xFF33383F),
  ),
  BadgeTier.gold: _TierPalette(
    Color(0xFFE5C07B),
    Color(0xFFCFA05C),
    Color(0xFF3A2A12),
  ),
  BadgeTier.diamond: _TierPalette(
    Color(0xFFD6F5FF),
    Color(0xFF7EC8E3),
    Color(0xFF123244),
  ),
  BadgeTier.special: _TierPalette(
    Color(0xFFCBB6FF),
    Color(0xFF8F6FE0),
    Color(0xFF2A1B54),
  ),
};

// Subtle per-family cast blended into the tier's metal so a badge's
// category reads at a glance without competing with the rank signal.
// Special-tier badges (behavioral/secret) don't get one — their palette is
// already visually distinct.
const _familyAccents = {
  BadgeFamily.streak: Color(0xFFFF7A45),
  BadgeFamily.square: Color(0xFF4CAF7D),
  BadgeFamily.cells: Color(0xFF4FA3E3),
  BadgeFamily.habits: Color(0xFF9B6BD9),
};

/// The medallion's glow/chip accent color for [tier] (blended with
/// [family]'s cast, same as the medallion body), for callers that need to
/// tint surrounding UI (e.g. a "badge unlocked" label) to match.
Color badgeTierGlow(BadgeTier tier, BadgeFamily? family) {
  final palette = _tierPalettes[tier]!;
  final accent = family != null ? _familyAccents[family] : null;
  return accent != null ? Color.lerp(palette.top, accent, 0.18)! : palette.top;
}

/// The ink color used for icons/text sitting directly on [tier]'s metal.
Color badgeTierInk(BadgeTier tier) => _tierPalettes[tier]!.ink;

/// A circular "medal" for a badge: a metal-gradient disc ranked by
/// [BadgeTier] with a soft glow and glossy highlight, or — when [tier] is
/// null (locked) — a muted disc with an optional static progress ring.
/// Shared by the badge grid, its detail dialog, and the unlock celebration
/// so all three read as the same object.
class BadgeMedallion extends StatelessWidget {
  final IconData icon;
  final BadgeTier? tier;
  final BadgeFamily? family;
  final double size;

  /// 0..1. Only rendered when [tier] is null (locked); ignored otherwise.
  final double? progress;

  /// Plays the unlock scale-in once. Never repeats, so it costs nothing
  /// once settled.
  final bool animateIn;

  const BadgeMedallion({
    super.key,
    required this.icon,
    this.tier,
    this.family,
    this.size = 76,
    this.progress,
    this.animateIn = false,
  });

  @override
  Widget build(BuildContext context) {
    if (tier == null) {
      return _LockedMedallion(icon: icon, size: size, progress: progress);
    }

    final palette = _tierPalettes[tier]!;
    final accent = family != null ? _familyAccents[family] : null;
    final top = accent != null
        ? Color.lerp(palette.top, accent, 0.18)!
        : palette.top;
    final bottom = accent != null
        ? Color.lerp(palette.bottom, accent, 0.18)!
        : palette.bottom;

    final medallion = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, bottom],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: palette.ink, size: size * 0.44),
          // Glossy top-left highlight for a medal-like shine.
          IgnorePointer(
            child: Container(
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
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: top.withValues(alpha: 0.4),
                blurRadius: size * 0.4,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        animateIn
            ? medallion.animate().scale(
                duration: 500.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0.3, 0.3),
                end: const Offset(1, 1),
              )
            : medallion,
      ],
    );
  }
}

class _LockedMedallion extends StatelessWidget {
  final IconData icon;
  final double size;
  final double? progress;

  const _LockedMedallion({
    required this.icon,
    required this.size,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (progress != null)
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progress!.clamp(0, 1),
                strokeWidth: size * 0.045,
                backgroundColor: Colors.grey.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(
                  Colors.grey.withValues(alpha: 0.6),
                ),
              ),
            ),
          Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Icon(
              icon,
              color: Colors.grey.withValues(alpha: 0.55),
              size: size * 0.36,
            ),
          ),
        ],
      ),
    );
  }
}
