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
  String get onboardingTitle5 => 'Go further with Pro';

  @override
  String get onboardingDesc5 =>
      'Unlock unlimited habits, all penalty modes, reminders, and more. Or start free — you can upgrade anytime.';

  @override
  String get continueFree => 'Continue Free';

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
  String get yearlySubtitle => 'Best value';

  @override
  String get perMonth => '/mo';

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get monthly => 'Monthly';

  @override
  String get monthlySubtitle => 'Cancel anytime';

  @override
  String get lifetimeOffer => 'Lifetime access →';

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
  String get themeProTitle => 'Pro theme';

  @override
  String get themeProDescription =>
      'Light mode and future themes are available with Pro. Customize your experience!';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get proOnly => 'Pro';

  @override
  String get freeLimitedHistory => 'Full history available with Pro';

  @override
  String get productNotAvailable =>
      'Product not available. Try installing from Play Store or run in release mode.';

  @override
  String get badgesTitle => 'Badges';

  @override
  String badgesUnlockedCount(int count, int total) {
    return '$count of $total unlocked';
  }

  @override
  String get badgeUnlockedTitle => 'BADGE UNLOCKED';

  @override
  String badgeUnlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get badgeSecretLockedName => '???';

  @override
  String get badgeSecretLockedHint =>
      'Keep going — this one reveals itself when you earn it.';

  @override
  String get badgeStreak7Name => 'Week Warrior';

  @override
  String get badgeStreak7Desc => 'Reached a 7-day streak on a habit.';

  @override
  String get badgeStreak30Name => 'Momentum Builder';

  @override
  String get badgeStreak30Desc =>
      'Reached a 30-day streak. Real habits are forming.';

  @override
  String get badgeStreak100Name => 'Centurion';

  @override
  String get badgeStreak100Desc =>
      '100 consecutive days. This is who you are now.';

  @override
  String get badgeStreak365Name => 'Full Circle';

  @override
  String get badgeStreak365Desc => 'A full year, one day at a time.';

  @override
  String get badgeSquare1Name => 'First Stone';

  @override
  String get badgeSquare1Desc => 'Completed your first 1×1 square.';

  @override
  String get badgeSquare2Name => 'Foundation Laid';

  @override
  String get badgeSquare2Desc => 'Completed a 2×2 square.';

  @override
  String get badgeSquare3Name => 'Building Up';

  @override
  String get badgeSquare3Desc => 'Completed a 3×3 square.';

  @override
  String get badgeSquare5Name => 'Architect';

  @override
  String get badgeSquare5Desc => 'Completed a 5×5 square.';

  @override
  String get badgeSquare8Name => 'Master Builder';

  @override
  String get badgeSquare8Desc => 'Completed an 8×8 square.';

  @override
  String get badgeCells10Name => 'Getting Started';

  @override
  String get badgeCells10Desc => '10 total validated days across all habits.';

  @override
  String get badgeCells50Name => 'Steady Hands';

  @override
  String get badgeCells50Desc => '50 total validated days.';

  @override
  String get badgeCells100Name => 'Century Club';

  @override
  String get badgeCells100Desc => '100 total validated days.';

  @override
  String get badgeCells500Name => 'Iron Will';

  @override
  String get badgeCells500Desc => '500 total validated days.';

  @override
  String get badgeCells1000Name => 'Legend';

  @override
  String get badgeCells1000Desc => '1000 total validated days. Extraordinary.';

  @override
  String get badgeHabits3Name => 'Multitasker';

  @override
  String get badgeHabits3Desc => 'Tracking 3 habits at once.';

  @override
  String get badgeHabits5Name => 'Juggler';

  @override
  String get badgeHabits5Desc => 'Tracking 5 habits at once.';

  @override
  String get badgeHabits10Name => 'Habit Collector';

  @override
  String get badgeHabits10Desc => 'Tracking 10 habits at once.';

  @override
  String get badgeEarlyBirdName => 'Early Bird';

  @override
  String get badgeEarlyBirdDesc => 'Validated a habit before 7am.';

  @override
  String get badgeNightOwlName => 'Night Owl';

  @override
  String get badgeNightOwlDesc => 'Validated a habit at 10pm or later.';

  @override
  String get badgeWeekendWarriorName => 'Weekend Warrior';

  @override
  String get badgeWeekendWarriorDesc =>
      'Stayed consistent on both Saturday and Sunday.';

  @override
  String get badgeComebackName => 'The Comeback';

  @override
  String get badgeComebackDesc =>
      'Returned and validated after missing 3+ days in a row.';

  @override
  String get badgePerfectWeekName => 'Perfect Week';

  @override
  String get badgePerfectWeekDesc => '7 days in a row, zero misses.';

  @override
  String get badgePerfectMonthName => 'Perfect Month';

  @override
  String get badgePerfectMonthDesc => '30 days in a row, zero misses.';

  @override
  String get badgeHardcoreSurvivorName => 'Hardcore Survivor';

  @override
  String get badgeHardcoreSurvivorDesc =>
      'Survived 30 days on Hardcore mode without a reset.';

  @override
  String get badgeZenMasterName => 'Zen Master';

  @override
  String get badgeZenMasterDesc => '100 validated days on Zen mode.';

  @override
  String get badgeSecretPerfectionistName => 'The Perfectionist';

  @override
  String get badgeSecretPerfectionistDesc =>
      'Never missed a single day across 20+ entries.';

  @override
  String get badgeSecretMultitaskerName => 'Five-Ring Focus';

  @override
  String get badgeSecretMultitaskerDesc =>
      'Kept 5 habits alive with an active streak at the same time.';

  @override
  String get shareMyProgress => 'Share my progress';

  @override
  String get shareFindOnAppStore => 'Search \"Moto\" on the App Store.';

  @override
  String get shareAppMsg1 =>
      'I\'m building better habits with Moto — one square at a time. 🧱 Come build yours.';

  @override
  String get shareAppMsg2 =>
      'Found an app that actually makes habits stick: Moto. Turns your consistency into visual progress. 🌱';

  @override
  String get shareAppMsg3 =>
      'Moto turned my daily habits into something I can actually see grow. Try it. 元';

  @override
  String get shareAppMsg4 =>
      'No streak-shaming, just squares that grow with you. Moto is worth a look. 🧩';

  @override
  String get shareAppMsg5 =>
      'I\'ve been building my foundation, one validated day at a time, with Moto. Join me?';

  @override
  String get shareAppMsg6 =>
      'This habit tracker made consistency feel like a game I actually want to win. Moto. 🏆';

  @override
  String get shareAppMsg7 =>
      'Small daily actions, visualized as growing squares. That\'s Moto — give it a shot.';

  @override
  String shareProgressMsg1(String habitName, int streak) {
    return '$streak cells and counting on \"$habitName\" with Moto. Building my foundation, one day at a time. 🧱';
  }

  @override
  String shareProgressMsg2(String habitName, int streak) {
    return 'Day by day, \"$habitName\" is turning into something real — $streak cells so far on Moto. 🌱';
  }

  @override
  String shareProgressMsg3(String habitName, int streak) {
    return '$streak validated days on \"$habitName\". Moto is keeping me honest. 元';
  }

  @override
  String shareProgressMsg4(String habitName, int streak) {
    return 'Watching \"$habitName\" grow square by square — $streak cells in on Moto.';
  }

  @override
  String shareProgressMsg5(String habitName, int streak) {
    return 'My \"$habitName\" streak just hit $streak cells on Moto. Small steps, real progress.';
  }

  @override
  String shareBadgeMsg1(String badgeName) {
    return 'Just unlocked the \"$badgeName\" badge on Moto! 🏆';
  }

  @override
  String shareBadgeMsg2(String badgeName) {
    return 'New trophy unlocked: \"$badgeName\" on Moto. Feels good. 元';
  }

  @override
  String shareBadgeMsg3(String badgeName) {
    return 'Consistency paid off — earned the \"$badgeName\" badge on Moto!';
  }

  @override
  String shareBadgeMsg4(String badgeName) {
    return '\"$badgeName\" — unlocked on Moto. One more proof the small stuff adds up.';
  }

  @override
  String shareBadgeMsg5(String badgeName) {
    return 'Moto just gave me the \"$badgeName\" badge. Onward. 🌱';
  }

  @override
  String shareSquareMsg1(String habitName, int level) {
    return 'Just completed a $level×$level square on \"$habitName\" with Moto! 🧱';
  }

  @override
  String shareSquareMsg2(String habitName, int level) {
    return '\"$habitName\" leveled up — $level×$level square complete on Moto.';
  }

  @override
  String shareSquareMsg3(String habitName, int level) {
    return 'Another trophy earned: $level×$level on \"$habitName\". Moto keeps the proof. 元';
  }

  @override
  String shareSquareMsg4(String habitName, int level) {
    return 'Square complete! $level×$level on \"$habitName\" — built one validated day at a time.';
  }

  @override
  String shareSquareMsg5(String habitName, int level) {
    return '\"$habitName\" just hit a $level×$level square on Moto. Consistency, visualized.';
  }

  @override
  String squareCompletedCelebration(int count) {
    return '🎉 Square completed! You just finished a $count×$count.';
  }

  @override
  String streakMilestoneCelebration(int streak) {
    return '🔥 $streak-day streak! Keep the momentum going.';
  }

  @override
  String get proDowngradeTitle => 'Your Pro subscription has ended';

  @override
  String get proDowngradeDescription =>
      'No worries — all your habits and history are safe. You\'re back on the free plan for now. Resubscribe anytime to unlock everything again.';

  @override
  String get proPromoCardTitle => 'Go further with Pro';

  @override
  String get proPromoCardSubtitle =>
      'Unlimited habits, full history, and more.';

  @override
  String get proSocialProof =>
      'Join thousands building better habits with Moto Pro';

  @override
  String get editHistoryProTitle => 'Edit full history';

  @override
  String get editHistoryProDescription =>
      'Editing dates older than 7 days is available with Pro. Free accounts can correct the last week.';

  @override
  String get clearDay => 'Clear this day';

  @override
  String get dailyQuoteNotification => 'Daily quote';

  @override
  String get dailyQuoteNotificationDescription =>
      'One motivational thought every morning at 8:00, free for everyone';

  @override
  String get quietHours => 'Quiet hours';

  @override
  String get quietHoursDescription =>
      'Reminders won\'t be sent during this window';

  @override
  String get quietHoursStart => 'Start';

  @override
  String get quietHoursEnd => 'End';

  @override
  String get sendTestNotification => 'Send test notification';

  @override
  String get sendTestNotificationDescription =>
      'Verify your reminders are working correctly';

  @override
  String get testNotificationBody =>
      'This is a test notification from Moto. If you can see this, reminders are working! 🔔';

  @override
  String get testNotificationSent => 'Test notification sent';

  @override
  String reminderGentle1(String habit) {
    return 'No pressure — just $habit, whenever you\'re ready today.';
  }

  @override
  String reminderGentle2(String habit) {
    return 'A gentle nudge: $habit is waiting for you.';
  }

  @override
  String reminderGentle3(String habit) {
    return 'Whenever you get a moment today, $habit would love the attention.';
  }

  @override
  String reminderPlayful1(String habit) {
    return 'Psst. $habit called. It misses you.';
  }

  @override
  String reminderPlayful2(String habit) {
    return 'Your square is waiting to grow. Feed it some $habit today.';
  }

  @override
  String reminderPlayful3(String habit) {
    return 'Plot twist: today is a great day for $habit.';
  }

  @override
  String reminderWeekendVibe(String habit) {
    return 'Weekend or not, $habit doesn\'t take days off.';
  }

  @override
  String reminderStreakMilestone(String habit, int streak) {
    return '$streak days strong on $habit. Don\'t stop now.';
  }
}
