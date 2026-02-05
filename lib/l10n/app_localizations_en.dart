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
  String get zenDescription =>
      'Gentle progress — miss a day, lose just 1 point. Perfect for building habits without pressure.';

  @override
  String get standardDescription =>
      'Balanced challenge — miss a day, drop to the previous level. Keeps you motivated without being harsh.';

  @override
  String get hardcoreDescription =>
      'No mercy — miss a day, start over from zero. For those who thrive under pressure.';

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

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get theme => 'Theme';

  @override
  String get supportSection => 'Support';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get sendFeedbackDescription =>
      'Report a bug or suggest an improvement';

  @override
  String get shareApp => 'Share Moto';

  @override
  String get shareAppDescription => 'Recommend Moto to your friends';

  @override
  String get shareMessage =>
      'I\'m building better habits with Moto! Join me and start building your foundation, one day at a time. 🧱';

  @override
  String get feedbackSubject => 'Moto Feedback';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDescription => 'Manage your reminder preferences';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => '元 — The Origin';

  @override
  String get onboardingDesc1 =>
      'In Japanese, 元 (Moto) means \'origin\' or \'foundation\'. Every great achievement starts with a single action. Today, you lay the first stone.';

  @override
  String get onboardingTitle2 => 'Build, brick by brick';

  @override
  String get onboardingDesc2 =>
      'No magic streaks here. Every validated day adds a cell to your square. 1×1, then 2×2, then 3×3... You literally watch your discipline take shape.';

  @override
  String get onboardingTitle3 => 'Your victories remain';

  @override
  String get onboardingDesc3 =>
      'Each completed square becomes a golden trophy — proof of your consistency. Even if you stumble, your trophies stay. You never truly start from zero.';

  @override
  String get onboardingTitle4 => 'Choose your path';

  @override
  String get onboardingDesc4 =>
      '🌱 Zen: Progress gently, lose one cell.\n⚡ Standard: Lose your current square.\n🔥 Hardcore: Start over completely.';

  @override
  String get replayOnboarding => 'Replay introduction';

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get couldNotOpenEmail => 'Could not open email client';

  @override
  String get unlockFullPotential => 'Unlock your full potential';

  @override
  String get proDescription =>
      'Get unlimited habits, all penalty modes, and powerful features to build lasting habits.';

  @override
  String get proFeature1 => 'Unlimited habits';

  @override
  String get proFeature2 => 'All penalty modes (Zen, Standard, Hardcore)';

  @override
  String get proFeature3 => 'Complete history & calendar';

  @override
  String get proFeature4 => 'Custom notifications per habit';

  @override
  String get proFeature5 => 'Future updates & themes';

  @override
  String get yearly => 'Yearly';

  @override
  String get yearlySubtitle => 'Only 1,66€/month';

  @override
  String get monthly => 'Monthly';

  @override
  String get monthlySubtitle => 'Cancel anytime';

  @override
  String get lifetimeOffer => 'Lifetime access for 39,99€ →';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get proActivated => 'Pro activated! 🎉';

  @override
  String get noPurchasesFound => 'No purchases found';

  @override
  String get habitLimitReached => 'Free limit reached';

  @override
  String get upgradeToAddMore => 'Upgrade to Pro for unlimited habits';

  @override
  String get penaltyModeProTitle => 'Pro mode';

  @override
  String get penaltyModeProDescription =>
      'Zen and Hardcore modes are available with Pro. Try different challenge levels!';

  @override
  String get reminderProTitle => 'Pro feature';

  @override
  String get reminderProDescription =>
      'Custom reminders for each habit are available with Pro. Never miss a day!';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get proOnly => 'Pro';

  @override
  String get freeLimitedHistory => 'Full history available with Pro';
}
