import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_en.dart';
import '../l10n/app_localizations_fr.dart';
import '../l10n/app_localizations_ja.dart';
import '../models/habit.dart';

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

    return messages;
  }
}
