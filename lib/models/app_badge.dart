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
