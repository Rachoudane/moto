import 'package:flutter/material.dart';

enum BadgeType {
  streak7,
  streak30,
  streak100,
  streak365,
  square1,
  square2,
  square3,
  square5,
  square8,
  cells10,
  cells50,
  cells100,
  cells500,
  cells1000,
  habits3,
  habits5,
  habits10,
  earlyBird,
  nightOwl,
  weekendWarrior,
  comeback,
  perfectWeek,
  perfectMonth,
  hardcoreSurvivor,
  zenMaster,
  secretPerfectionist,
  secretMultitasker,
}

/// Badges whose name/description should stay hidden ("???") until unlocked.
const Set<BadgeType> secretBadgeTypes = {
  BadgeType.secretPerfectionist,
  BadgeType.secretMultitasker,
};

/// Visual rank for a badge's medallion. The four "countable" families
/// (streak/square/cells/habits) escalate bronze → diamond as their
/// threshold rises; behavioral and secret badges aren't part of an ordered
/// progression, so they get a distinct "special" look instead of a rank.
enum BadgeTier { bronze, silver, gold, diamond, special }

const Map<BadgeType, BadgeTier> badgeTiers = {
  BadgeType.streak7: BadgeTier.bronze,
  BadgeType.streak30: BadgeTier.silver,
  BadgeType.streak100: BadgeTier.gold,
  BadgeType.streak365: BadgeTier.diamond,
  BadgeType.square1: BadgeTier.bronze,
  BadgeType.square2: BadgeTier.bronze,
  BadgeType.square3: BadgeTier.silver,
  BadgeType.square5: BadgeTier.gold,
  BadgeType.square8: BadgeTier.diamond,
  BadgeType.cells10: BadgeTier.bronze,
  BadgeType.cells50: BadgeTier.silver,
  BadgeType.cells100: BadgeTier.gold,
  BadgeType.cells500: BadgeTier.gold,
  BadgeType.cells1000: BadgeTier.diamond,
  BadgeType.habits3: BadgeTier.bronze,
  BadgeType.habits5: BadgeTier.silver,
  BadgeType.habits10: BadgeTier.diamond,
  BadgeType.earlyBird: BadgeTier.special,
  BadgeType.nightOwl: BadgeTier.special,
  BadgeType.weekendWarrior: BadgeTier.special,
  BadgeType.comeback: BadgeTier.special,
  BadgeType.perfectWeek: BadgeTier.special,
  BadgeType.perfectMonth: BadgeTier.special,
  BadgeType.hardcoreSurvivor: BadgeTier.special,
  BadgeType.zenMaster: BadgeTier.special,
  BadgeType.secretPerfectionist: BadgeTier.special,
  BadgeType.secretMultitasker: BadgeTier.special,
};

/// Per-family accent hue, subtly blended into the tier's metal gradient so
/// a badge's category reads at a glance without competing with the
/// bronze/silver/gold/diamond rank signal.
enum BadgeFamily { streak, square, cells, habits, special }

const Map<BadgeType, BadgeFamily> badgeFamilies = {
  BadgeType.streak7: BadgeFamily.streak,
  BadgeType.streak30: BadgeFamily.streak,
  BadgeType.streak100: BadgeFamily.streak,
  BadgeType.streak365: BadgeFamily.streak,
  BadgeType.square1: BadgeFamily.square,
  BadgeType.square2: BadgeFamily.square,
  BadgeType.square3: BadgeFamily.square,
  BadgeType.square5: BadgeFamily.square,
  BadgeType.square8: BadgeFamily.square,
  BadgeType.cells10: BadgeFamily.cells,
  BadgeType.cells50: BadgeFamily.cells,
  BadgeType.cells100: BadgeFamily.cells,
  BadgeType.cells500: BadgeFamily.cells,
  BadgeType.cells1000: BadgeFamily.cells,
  BadgeType.habits3: BadgeFamily.habits,
  BadgeType.habits5: BadgeFamily.habits,
  BadgeType.habits10: BadgeFamily.habits,
  BadgeType.earlyBird: BadgeFamily.special,
  BadgeType.nightOwl: BadgeFamily.special,
  BadgeType.weekendWarrior: BadgeFamily.special,
  BadgeType.comeback: BadgeFamily.special,
  BadgeType.perfectWeek: BadgeFamily.special,
  BadgeType.perfectMonth: BadgeFamily.special,
  BadgeType.hardcoreSurvivor: BadgeFamily.special,
  BadgeType.zenMaster: BadgeFamily.special,
  BadgeType.secretPerfectionist: BadgeFamily.special,
  BadgeType.secretMultitasker: BadgeFamily.special,
};

const Map<BadgeType, IconData> badgeIcons = {
  BadgeType.streak7: Icons.local_fire_department_outlined,
  BadgeType.streak30: Icons.local_fire_department,
  BadgeType.streak100: Icons.whatshot,
  BadgeType.streak365: Icons.emoji_events,
  BadgeType.square1: Icons.crop_square,
  BadgeType.square2: Icons.grid_view,
  BadgeType.square3: Icons.grid_on,
  BadgeType.square5: Icons.apps,
  BadgeType.square8: Icons.dashboard_customize,
  BadgeType.cells10: Icons.grain,
  BadgeType.cells50: Icons.blur_on,
  BadgeType.cells100: Icons.scatter_plot,
  BadgeType.cells500: Icons.auto_awesome_mosaic,
  BadgeType.cells1000: Icons.diamond,
  BadgeType.habits3: Icons.list_alt,
  BadgeType.habits5: Icons.checklist,
  BadgeType.habits10: Icons.dashboard,
  BadgeType.earlyBird: Icons.wb_twilight,
  BadgeType.nightOwl: Icons.nightlight_round,
  BadgeType.weekendWarrior: Icons.weekend,
  BadgeType.comeback: Icons.refresh,
  BadgeType.perfectWeek: Icons.verified,
  BadgeType.perfectMonth: Icons.military_tech,
  BadgeType.hardcoreSurvivor: Icons.whatshot,
  BadgeType.zenMaster: Icons.self_improvement,
  BadgeType.secretPerfectionist: Icons.stars,
  BadgeType.secretMultitasker: Icons.hub,
};

class AppBadge {
  final BadgeType type;
  final DateTime unlockedAt;

  AppBadge({required this.type, required this.unlockedAt});

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'unlockedAt': unlockedAt.toIso8601String(),
  };

  factory AppBadge.fromJson(Map<String, dynamic> json) => AppBadge(
    type: BadgeType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => BadgeType.streak7,
    ),
    unlockedAt: DateTime.parse(json['unlockedAt']),
  );
}
