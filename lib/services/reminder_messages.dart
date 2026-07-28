import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_en.dart';
import '../l10n/app_localizations_fr.dart';
import '../l10n/app_localizations_ja.dart';
import '../models/habit.dart';
import 'motivation_service.dart';

class ReminderMessages {
  static AppLocalizations _getLocalizations(String locale) {
    switch (locale) {
      case 'fr':
        return AppLocalizationsFr();
      case 'ja':
        return AppLocalizationsJa();
      default:
        return AppLocalizationsEn();
    }
  }

  static String getContextualMessage({
    required Habit habit,
    required String locale,
  }) {
    final now = DateTime.now();
    final hour = now.hour;
    final streak = habit.streak;
    final habitName = habit.name;
    final l10n = _getLocalizations(locale);

    // Determine time of day
    final String timeOfDay;
    if (hour >= 6 && hour < 12) {
      timeOfDay = 'morning';
    } else if (hour >= 12 && hour < 18) {
      timeOfDay = 'afternoon';
    } else {
      timeOfDay = 'evening';
    }

    // Determine progress level
    final String progressLevel;
    if (streak < 5) {
      progressLevel = 'beginner';
    } else if (streak < 25) {
      progressLevel = 'intermediate';
    } else {
      progressLevel = 'advanced';
    }

    final messages = _buildMessages(
      l10n: l10n,
      habitName: habitName,
      isQuitting: habit.isQuitting,
      timeOfDay: timeOfDay,
      progressLevel: progressLevel,
      streak: streak,
      locale: locale,
      isWeekend: now.weekday == DateTime.saturday || now.weekday == DateTime.sunday,
    );

    // Return random message
    if (messages.isEmpty) {
      return "Time for $habitName!";
    }
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  static List<String> _buildMessages({
    required AppLocalizations l10n,
    required String habitName,
    required bool isQuitting,
    required String timeOfDay,
    required String progressLevel,
    required int streak,
    required String locale,
    required bool isWeekend,
  }) {
    final messages = <String>[];

    if (isQuitting) {
      // Time-of-day specific messages
      switch (timeOfDay) {
        case 'morning':
          messages.add(
            l10n.reminderQuittingMorning(habitName),
          );
          break;
        case 'afternoon':
          messages.add(
            l10n.reminderQuittingAfternoon(habitName),
          );
          break;
        case 'evening':
          messages.add(
            l10n.reminderQuittingEvening(habitName),
          );
          break;
      }

      // General quitting messages
      messages.add(l10n.reminderQuittingVictory(habitName));
      messages.add(l10n.reminderQuittingWillpower(habitName));

      // Progress-level specific messages
      switch (progressLevel) {
        case 'beginner':
          messages.add(l10n.reminderQuittingBeginnerGeneral(habitName));
          messages.add(l10n.reminderQuittingBeginnerMotivation(habitName));
          break;
        case 'intermediate':
          messages.add(l10n.reminderQuittingIntermediateGeneral(habitName));
          messages.add(l10n.reminderQuittingIntermediateMotivation(habitName));
          break;
        case 'advanced':
          messages.add(l10n.reminderQuittingAdvancedGeneral(habitName));
          messages.add(l10n.reminderQuittingAdvancedMotivation(habitName));
          break;
      }
    } else {
      // Time-of-day specific messages
      switch (timeOfDay) {
        case 'morning':
          messages.add(
            l10n.reminderBuildingMorning(habitName),
          );
          break;
        case 'afternoon':
          messages.add(
            l10n.reminderBuildingAfternoon(habitName),
          );
          break;
        case 'evening':
          messages.add(
            l10n.reminderBuildingEvening(habitName),
          );
          break;
      }

      // General building messages
      messages.add(l10n.reminderBuildingSuccess(habitName));
      messages.add(l10n.reminderBuildingFoundation(habitName));
      messages.add(l10n.reminderBuildingMomentum(habitName));

      // Progress-level specific messages
      switch (progressLevel) {
        case 'beginner':
          messages.add(l10n.reminderBeginnerGeneral(habitName));
          messages.add(l10n.reminderBeginnerMotivation(habitName));
          break;
        case 'intermediate':
          messages.add(l10n.reminderIntermediateGeneral(habitName));
          messages.add(l10n.reminderIntermediateMotivation(habitName));
          break;
        case 'advanced':
          messages.add(l10n.reminderAdvancedGeneral(habitName));
          messages.add(l10n.reminderAdvancedMotivation(habitName));
          break;
      }
    }

    // Gentle nudges, playful variants and quote-of-day push the pool past
    // 20 distinct variants per language while staying contextually
    // relevant. Each has a quitting-specific counterpart since "just do
    // {habit}" reads backwards for a habit someone is trying to avoid.
    if (isQuitting) {
      messages.add(l10n.reminderQuittingGentle1(habitName));
      messages.add(l10n.reminderQuittingGentle2(habitName));
      messages.add(l10n.reminderQuittingGentle3(habitName));
      messages.add(l10n.reminderQuittingPlayful1(habitName));
      messages.add(l10n.reminderQuittingPlayful2(habitName));
      messages.add(l10n.reminderQuittingPlayful3(habitName));
    } else {
      messages.add(l10n.reminderGentle1(habitName));
      messages.add(l10n.reminderGentle2(habitName));
      messages.add(l10n.reminderGentle3(habitName));
      messages.add(l10n.reminderPlayful1(habitName));
      messages.add(l10n.reminderPlayful2(habitName));
      messages.add(l10n.reminderPlayful3(habitName));
    }

    if (isWeekend) {
      messages.add(
        isQuitting
            ? l10n.reminderQuittingWeekendVibe(habitName)
            : l10n.reminderWeekendVibe(habitName),
      );
    }

    const milestones = [7, 14, 30, 50, 100, 200, 365];
    if (milestones.contains(streak)) {
      messages.add(
        isQuitting
            ? l10n.reminderQuittingStreakMilestone(habitName, streak)
            : l10n.reminderStreakMilestone(habitName, streak),
      );
    }

    if (timeOfDay == 'morning') {
      messages.add(MotivationService.getTodayQuote(locale));
    }

    return messages;
  }
}
