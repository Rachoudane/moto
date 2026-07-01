import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/app_badge.dart';
import '../models/habit.dart';

/// Builds and sends rich, varied, localized share messages for viral growth
/// moments (app invite, progress, badge unlocks, square completions).
class ShareService {
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.rachoucorp.moto';

  static bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  static int get _dailyPick => DateTime.now().millisecondsSinceEpoch;

  static String _withStoreLink(String message, AppLocalizations l10n) {
    if (_isAndroid) {
      return '$message\n\n$_playStoreUrl';
    }
    return '$message\n\n${l10n.shareFindOnAppStore}';
  }

  static Future<void> shareApp(AppLocalizations l10n) async {
    final variants = [
      l10n.shareAppMsg1,
      l10n.shareAppMsg2,
      l10n.shareAppMsg3,
      l10n.shareAppMsg4,
      l10n.shareAppMsg5,
      l10n.shareAppMsg6,
      l10n.shareAppMsg7,
    ];
    final message = variants[_dailyPick % variants.length];
    await SharePlus.instance.share(
      ShareParams(text: _withStoreLink(message, l10n)),
    );
  }

  static Future<void> shareProgress(Habit habit, AppLocalizations l10n) async {
    final streak = habit.streak;
    final variants = [
      l10n.shareProgressMsg1(habit.name, streak),
      l10n.shareProgressMsg2(habit.name, streak),
      l10n.shareProgressMsg3(habit.name, streak),
      l10n.shareProgressMsg4(habit.name, streak),
      l10n.shareProgressMsg5(habit.name, streak),
    ];
    final message = variants[_dailyPick % variants.length];
    await SharePlus.instance.share(
      ShareParams(text: _withStoreLink(message, l10n)),
    );
  }

  static Future<void> shareBadge(AppBadge badge, AppLocalizations l10n) async {
    final name = badgeName(badge.type, l10n);
    final variants = [
      l10n.shareBadgeMsg1(name),
      l10n.shareBadgeMsg2(name),
      l10n.shareBadgeMsg3(name),
      l10n.shareBadgeMsg4(name),
      l10n.shareBadgeMsg5(name),
    ];
    final message = variants[_dailyPick % variants.length];
    await SharePlus.instance.share(
      ShareParams(text: _withStoreLink(message, l10n)),
    );
  }

  static Future<void> shareSquareCompletion(
    Habit habit,
    int level,
    AppLocalizations l10n,
  ) async {
    final variants = [
      l10n.shareSquareMsg1(habit.name, level),
      l10n.shareSquareMsg2(habit.name, level),
      l10n.shareSquareMsg3(habit.name, level),
      l10n.shareSquareMsg4(habit.name, level),
      l10n.shareSquareMsg5(habit.name, level),
    ];
    final message = variants[_dailyPick % variants.length];
    await SharePlus.instance.share(
      ShareParams(text: _withStoreLink(message, l10n)),
    );
  }

  static Future<void> shareQuote(String quote, AppLocalizations l10n) async {
    await SharePlus.instance.share(
      ShareParams(text: _withStoreLink('"$quote"\n\n— Moto 元', l10n)),
    );
  }

  /// Localized badge display name, resolved outside this service so both
  /// the badges screen and share messages stay in sync.
  static String badgeName(BadgeType type, AppLocalizations l10n) {
    switch (type) {
      case BadgeType.streak7:
        return l10n.badgeStreak7Name;
      case BadgeType.streak30:
        return l10n.badgeStreak30Name;
      case BadgeType.streak100:
        return l10n.badgeStreak100Name;
      case BadgeType.streak365:
        return l10n.badgeStreak365Name;
      case BadgeType.square1:
        return l10n.badgeSquare1Name;
      case BadgeType.square2:
        return l10n.badgeSquare2Name;
      case BadgeType.square3:
        return l10n.badgeSquare3Name;
      case BadgeType.square5:
        return l10n.badgeSquare5Name;
      case BadgeType.square8:
        return l10n.badgeSquare8Name;
      case BadgeType.cells10:
        return l10n.badgeCells10Name;
      case BadgeType.cells50:
        return l10n.badgeCells50Name;
      case BadgeType.cells100:
        return l10n.badgeCells100Name;
      case BadgeType.cells500:
        return l10n.badgeCells500Name;
      case BadgeType.cells1000:
        return l10n.badgeCells1000Name;
      case BadgeType.habits3:
        return l10n.badgeHabits3Name;
      case BadgeType.habits5:
        return l10n.badgeHabits5Name;
      case BadgeType.habits10:
        return l10n.badgeHabits10Name;
      case BadgeType.earlyBird:
        return l10n.badgeEarlyBirdName;
      case BadgeType.nightOwl:
        return l10n.badgeNightOwlName;
      case BadgeType.weekendWarrior:
        return l10n.badgeWeekendWarriorName;
      case BadgeType.comeback:
        return l10n.badgeComebackName;
      case BadgeType.perfectWeek:
        return l10n.badgePerfectWeekName;
      case BadgeType.perfectMonth:
        return l10n.badgePerfectMonthName;
      case BadgeType.hardcoreSurvivor:
        return l10n.badgeHardcoreSurvivorName;
      case BadgeType.zenMaster:
        return l10n.badgeZenMasterName;
      case BadgeType.secretPerfectionist:
        return l10n.badgeSecretPerfectionistName;
      case BadgeType.secretMultitasker:
        return l10n.badgeSecretMultitaskerName;
    }
  }

  static String badgeDescription(BadgeType type, AppLocalizations l10n) {
    switch (type) {
      case BadgeType.streak7:
        return l10n.badgeStreak7Desc;
      case BadgeType.streak30:
        return l10n.badgeStreak30Desc;
      case BadgeType.streak100:
        return l10n.badgeStreak100Desc;
      case BadgeType.streak365:
        return l10n.badgeStreak365Desc;
      case BadgeType.square1:
        return l10n.badgeSquare1Desc;
      case BadgeType.square2:
        return l10n.badgeSquare2Desc;
      case BadgeType.square3:
        return l10n.badgeSquare3Desc;
      case BadgeType.square5:
        return l10n.badgeSquare5Desc;
      case BadgeType.square8:
        return l10n.badgeSquare8Desc;
      case BadgeType.cells10:
        return l10n.badgeCells10Desc;
      case BadgeType.cells50:
        return l10n.badgeCells50Desc;
      case BadgeType.cells100:
        return l10n.badgeCells100Desc;
      case BadgeType.cells500:
        return l10n.badgeCells500Desc;
      case BadgeType.cells1000:
        return l10n.badgeCells1000Desc;
      case BadgeType.habits3:
        return l10n.badgeHabits3Desc;
      case BadgeType.habits5:
        return l10n.badgeHabits5Desc;
      case BadgeType.habits10:
        return l10n.badgeHabits10Desc;
      case BadgeType.earlyBird:
        return l10n.badgeEarlyBirdDesc;
      case BadgeType.nightOwl:
        return l10n.badgeNightOwlDesc;
      case BadgeType.weekendWarrior:
        return l10n.badgeWeekendWarriorDesc;
      case BadgeType.comeback:
        return l10n.badgeComebackDesc;
      case BadgeType.perfectWeek:
        return l10n.badgePerfectWeekDesc;
      case BadgeType.perfectMonth:
        return l10n.badgePerfectMonthDesc;
      case BadgeType.hardcoreSurvivor:
        return l10n.badgeHardcoreSurvivorDesc;
      case BadgeType.zenMaster:
        return l10n.badgeZenMasterDesc;
      case BadgeType.secretPerfectionist:
        return l10n.badgeSecretPerfectionistDesc;
      case BadgeType.secretMultitasker:
        return l10n.badgeSecretMultitaskerDesc;
    }
  }
}
