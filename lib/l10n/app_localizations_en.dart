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
}
