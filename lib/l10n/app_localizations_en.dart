// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Moto';

  @override
  String get appSubtitle => '元';

  @override
  String get buildYourBase => 'Build your foundation';

  @override
  String get noHabits => 'No habits yet';

  @override
  String get noHabitsSubtitle => 'Start building your foundation';

  @override
  String get newHabit => 'New habit';

  @override
  String get habitName => 'Habit name';

  @override
  String get toDo => 'To do';

  @override
  String get toQuit => 'To quit';

  @override
  String get penaltyMode => 'Penalty mode';

  @override
  String get zen => 'Zen';

  @override
  String get standard => 'Standard';

  @override
  String get hardcore => 'Hardcore';

  @override
  String get zenDescription => 'Lose 1 cell on failure';

  @override
  String get standardDescription => 'Lose current square on failure';

  @override
  String get hardcoreDescription => 'Back to zero on failure';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get skipped => 'Skipped';

  @override
  String get validated => '✓';

  @override
  String get deleteHabit => 'Delete this habit?';

  @override
  String deleteHabitConfirm(int count) {
    return 'You will lose your progress of $count cells.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get currentProgress => 'Current progress';

  @override
  String squareInProgress(int level) {
    return '$level×$level square in progress';
  }

  @override
  String get totalCells => 'Total cells';

  @override
  String completedSquares(int count) {
    return '$count completed square(s)';
  }

  @override
  String get settings => 'Settings';

  @override
  String get cells => 'cells';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get stop => 'STOP';

  @override
  String get history => 'History';

  @override
  String get statistics => 'Statistics';

  @override
  String get currentStreak => 'Current streak';

  @override
  String get longestStreak => 'Longest streak';

  @override
  String get successRate => 'Success rate';

  @override
  String get bestDay => 'Best day';

  @override
  String get totalDays => 'Total days';

  @override
  String get days => 'days';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get noDataYet => 'No data yet';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderEnabled => 'Daily reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String reminderSet(String time) {
    return 'Reminder set for $time';
  }

  @override
  String get noReminder => 'No reminder';

  @override
  String get permissionRequired => 'Notification permission required';

  @override
  String reminderBuildingMorning(String habit) {
    return 'Start your day strong with $habit';
  }

  @override
  String reminderBuildingAfternoon(String habit) {
    return 'Keep going! Time for $habit';
  }

  @override
  String reminderBuildingEvening(String habit) {
    return 'Cap off your day with $habit';
  }

  @override
  String reminderQuittingMorning(String habit) {
    return 'Start your day clean without $habit';
  }

  @override
  String reminderQuittingAfternoon(String habit) {
    return 'Stay strong: resist $habit today!';
  }

  @override
  String reminderQuittingEvening(String habit) {
    return 'End the day proud: you avoided $habit';
  }

  @override
  String reminderBeginnerGeneral(String habit) {
    return 'You\'re just getting started with $habit!';
  }

  @override
  String reminderBeginnerMotivation(String habit) {
    return 'First steps count: let\'s do $habit';
  }

  @override
  String reminderIntermediateGeneral(String habit) {
    return 'Look at your progress! Keep going with $habit';
  }

  @override
  String reminderIntermediateMotivation(String habit) {
    return 'Momentum is real: another day of $habit';
  }

  @override
  String reminderAdvancedGeneral(String habit) {
    return 'You\'re a champion! Keep the streak alive with $habit';
  }

  @override
  String reminderAdvancedMotivation(String habit) {
    return 'Mastery awaits: another day of $habit';
  }

  @override
  String reminderQuittingVictory(String habit) {
    return 'Every day without $habit is a victory';
  }

  @override
  String reminderQuittingWillpower(String habit) {
    return 'Break the chain with $habit - you can!';
  }

  @override
  String reminderBuildingSuccess(String habit) {
    return 'Success comes from consistency: $habit';
  }

  @override
  String reminderBuildingFoundation(String habit) {
    return 'Let\'s build: time for $habit!';
  }

  @override
  String reminderBuildingMomentum(String habit) {
    return 'You\'re unstoppable: do $habit today!';
  }

  @override
  String get todayStatus => 'Today\'s status';

  @override
  String get correctToday => 'Correct today';

  @override
  String get todayValidated => 'Today: Validated ✓';

  @override
  String get todaySkipped => 'Today: Skipped ✗';

  @override
  String get todayPending => 'Today: Pending';

  @override
  String get markAsValidated => 'Mark as validated';

  @override
  String get markAsSkipped => 'Mark as skipped';

  @override
  String get correctionWarning => 'This action will modify your streak';

  @override
  String get languageSection => 'Language';

  @override
  String get aboutSection => 'About';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get resetAllData => 'Reset all data';

  @override
  String get resetAllDataDescription =>
      'Delete all habits and progress permanently';

  @override
  String get resetAllDataConfirm =>
      'This will permanently delete all your habits and progress. This action cannot be undone.';

  @override
  String get reset => 'Reset';

  @override
  String get version => 'Version';

  @override
  String get appDescription => 'Build your foundation, one day at a time.';
}
