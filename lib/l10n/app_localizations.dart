import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Moto'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'元'**
  String get appSubtitle;

  /// No description provided for @buildYourBase.
  ///
  /// In en, this message translates to:
  /// **'Build your foundation'**
  String get buildYourBase;

  /// No description provided for @noHabits.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get noHabits;

  /// No description provided for @noHabitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start building your foundation'**
  String get noHabitsSubtitle;

  /// No description provided for @newHabit.
  ///
  /// In en, this message translates to:
  /// **'New habit'**
  String get newHabit;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitName;

  /// No description provided for @toDo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get toDo;

  /// No description provided for @toQuit.
  ///
  /// In en, this message translates to:
  /// **'To quit'**
  String get toQuit;

  /// No description provided for @penaltyMode.
  ///
  /// In en, this message translates to:
  /// **'Penalty mode'**
  String get penaltyMode;

  /// No description provided for @zen.
  ///
  /// In en, this message translates to:
  /// **'Zen'**
  String get zen;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @hardcore.
  ///
  /// In en, this message translates to:
  /// **'Hardcore'**
  String get hardcore;

  /// No description provided for @zenDescription.
  ///
  /// In en, this message translates to:
  /// **'Gentle progress — miss a day, lose just 1 point. Perfect for building habits without pressure.'**
  String get zenDescription;

  /// No description provided for @standardDescription.
  ///
  /// In en, this message translates to:
  /// **'Balanced challenge — miss a day, drop to the previous level. Keeps you motivated without being harsh.'**
  String get standardDescription;

  /// No description provided for @hardcoreDescription.
  ///
  /// In en, this message translates to:
  /// **'No mercy — miss a day, start over from zero. For those who thrive under pressure.'**
  String get hardcoreDescription;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @validated.
  ///
  /// In en, this message translates to:
  /// **'✓'**
  String get validated;

  /// No description provided for @deleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Delete this habit?'**
  String get deleteHabit;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In en, this message translates to:
  /// **'You will lose your progress of {count} cells.'**
  String deleteHabitConfirm(int count);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get editHabit;

  /// No description provided for @currentProgress.
  ///
  /// In en, this message translates to:
  /// **'Current progress'**
  String get currentProgress;

  /// No description provided for @squareInProgress.
  ///
  /// In en, this message translates to:
  /// **'{level}×{level} square in progress'**
  String squareInProgress(int level);

  /// No description provided for @totalCells.
  ///
  /// In en, this message translates to:
  /// **'Total cells'**
  String get totalCells;

  /// No description provided for @completedSquares.
  ///
  /// In en, this message translates to:
  /// **'{count} completed square(s)'**
  String completedSquares(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @cells.
  ///
  /// In en, this message translates to:
  /// **'cells'**
  String get cells;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get longestStreak;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success rate'**
  String get successRate;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get bestDay;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total days'**
  String get totalDays;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderEnabled;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {time}'**
  String reminderSet(String time);

  /// No description provided for @noReminder.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get noReminder;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get permissionRequired;

  /// No description provided for @reminderBuildingMorning.
  ///
  /// In en, this message translates to:
  /// **'Start your day strong with {habit}'**
  String reminderBuildingMorning(String habit);

  /// No description provided for @reminderBuildingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Keep going! Time for {habit}'**
  String reminderBuildingAfternoon(String habit);

  /// No description provided for @reminderBuildingEvening.
  ///
  /// In en, this message translates to:
  /// **'Cap off your day with {habit}'**
  String reminderBuildingEvening(String habit);

  /// No description provided for @reminderQuittingMorning.
  ///
  /// In en, this message translates to:
  /// **'Start your day clean without {habit}'**
  String reminderQuittingMorning(String habit);

  /// No description provided for @reminderQuittingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Stay strong: resist {habit} today!'**
  String reminderQuittingAfternoon(String habit);

  /// No description provided for @reminderQuittingEvening.
  ///
  /// In en, this message translates to:
  /// **'End the day proud: you avoided {habit}'**
  String reminderQuittingEvening(String habit);

  /// No description provided for @reminderBeginnerGeneral.
  ///
  /// In en, this message translates to:
  /// **'You\'re just getting started with {habit}!'**
  String reminderBeginnerGeneral(String habit);

  /// No description provided for @reminderBeginnerMotivation.
  ///
  /// In en, this message translates to:
  /// **'First steps count: let\'s do {habit}'**
  String reminderBeginnerMotivation(String habit);

  /// No description provided for @reminderIntermediateGeneral.
  ///
  /// In en, this message translates to:
  /// **'Look at your progress! Keep going with {habit}'**
  String reminderIntermediateGeneral(String habit);

  /// No description provided for @reminderIntermediateMotivation.
  ///
  /// In en, this message translates to:
  /// **'Momentum is real: another day of {habit}'**
  String reminderIntermediateMotivation(String habit);

  /// No description provided for @reminderAdvancedGeneral.
  ///
  /// In en, this message translates to:
  /// **'You\'re a champion! Keep the streak alive with {habit}'**
  String reminderAdvancedGeneral(String habit);

  /// No description provided for @reminderAdvancedMotivation.
  ///
  /// In en, this message translates to:
  /// **'Mastery awaits: another day of {habit}'**
  String reminderAdvancedMotivation(String habit);

  /// No description provided for @reminderQuittingVictory.
  ///
  /// In en, this message translates to:
  /// **'Every day without {habit} is a victory'**
  String reminderQuittingVictory(String habit);

  /// No description provided for @reminderQuittingWillpower.
  ///
  /// In en, this message translates to:
  /// **'Break the chain with {habit} - you can!'**
  String reminderQuittingWillpower(String habit);

  /// No description provided for @reminderBuildingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success comes from consistency: {habit}'**
  String reminderBuildingSuccess(String habit);

  /// No description provided for @reminderBuildingFoundation.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build: time for {habit}!'**
  String reminderBuildingFoundation(String habit);

  /// No description provided for @reminderBuildingMomentum.
  ///
  /// In en, this message translates to:
  /// **'You\'re unstoppable: do {habit} today!'**
  String reminderBuildingMomentum(String habit);

  /// No description provided for @todayStatus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s status'**
  String get todayStatus;

  /// No description provided for @correctToday.
  ///
  /// In en, this message translates to:
  /// **'Correct today'**
  String get correctToday;

  /// No description provided for @todayValidated.
  ///
  /// In en, this message translates to:
  /// **'Today: Validated ✓'**
  String get todayValidated;

  /// No description provided for @todaySkipped.
  ///
  /// In en, this message translates to:
  /// **'Today: Skipped ✗'**
  String get todaySkipped;

  /// No description provided for @todayPending.
  ///
  /// In en, this message translates to:
  /// **'Today: Pending'**
  String get todayPending;

  /// No description provided for @markAsValidated.
  ///
  /// In en, this message translates to:
  /// **'Mark as validated'**
  String get markAsValidated;

  /// No description provided for @markAsSkipped.
  ///
  /// In en, this message translates to:
  /// **'Mark as skipped'**
  String get markAsSkipped;

  /// No description provided for @correctionWarning.
  ///
  /// In en, this message translates to:
  /// **'This action will modify your streak'**
  String get correctionWarning;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get resetAllData;

  /// No description provided for @resetAllDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete all habits and progress permanently'**
  String get resetAllDataDescription;

  /// No description provided for @resetAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your habits and progress. This action cannot be undone.'**
  String get resetAllDataConfirm;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Build your foundation, one day at a time.'**
  String get appDescription;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or suggest an improvement'**
  String get sendFeedbackDescription;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share Moto'**
  String get shareApp;

  /// No description provided for @shareAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Recommend Moto to your friends'**
  String get shareAppDescription;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'I\'m building better habits with Moto! Join me and start building your foundation, one day at a time. 🧱'**
  String get shareMessage;

  /// No description provided for @feedbackSubject.
  ///
  /// In en, this message translates to:
  /// **'Moto Feedback'**
  String get feedbackSubject;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your reminder preferences'**
  String get notificationsDescription;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'元 — The Origin'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'In Japanese, 元 (Moto) means \'origin\' or \'foundation\'. Every great achievement starts with a single action. Today, you lay the first stone.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Build, brick by brick'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'No magic streaks here. Every validated day adds a cell to your square. 1×1, then 2×2, then 3×3... You literally watch your discipline take shape.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Your victories remain'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Each completed square becomes a golden trophy — proof of your consistency. Even if you stumble, your trophies stay. You never truly start from zero.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Choose your path'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'🌱 Zen: Progress gently, lose one cell.\n⚡ Standard: Lose your current square.\n🔥 Hardcore: Start over completely.'**
  String get onboardingDesc4;

  /// No description provided for @onboardingTitle5.
  ///
  /// In en, this message translates to:
  /// **'Go further with Pro'**
  String get onboardingTitle5;

  /// No description provided for @onboardingDesc5.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited habits, all penalty modes, reminders, and more. Or start free — you can upgrade anytime.'**
  String get onboardingDesc5;

  /// No description provided for @continueFree.
  ///
  /// In en, this message translates to:
  /// **'Continue Free'**
  String get continueFree;

  /// No description provided for @replayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay introduction'**
  String get replayOnboarding;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @couldNotOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Could not open email client'**
  String get couldNotOpenEmail;

  /// No description provided for @unlockFullPotential.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full potential'**
  String get unlockFullPotential;

  /// No description provided for @proDescription.
  ///
  /// In en, this message translates to:
  /// **'Get unlimited habits, all penalty modes, and powerful features to build lasting habits.'**
  String get proDescription;

  /// No description provided for @proFeature1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited habits'**
  String get proFeature1;

  /// No description provided for @proFeature2.
  ///
  /// In en, this message translates to:
  /// **'All penalty modes (Zen, Standard, Hardcore)'**
  String get proFeature2;

  /// No description provided for @proFeature3.
  ///
  /// In en, this message translates to:
  /// **'Complete history & calendar'**
  String get proFeature3;

  /// No description provided for @proFeature4.
  ///
  /// In en, this message translates to:
  /// **'Custom notifications per habit'**
  String get proFeature4;

  /// No description provided for @proFeature5.
  ///
  /// In en, this message translates to:
  /// **'Future updates & themes'**
  String get proFeature5;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @yearlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get yearlySubtitle;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @monthlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get monthlySubtitle;

  /// No description provided for @lifetimeOffer.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access →'**
  String get lifetimeOffer;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @proActivated.
  ///
  /// In en, this message translates to:
  /// **'Pro activated! 🎉'**
  String get proActivated;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No purchases found'**
  String get noPurchasesFound;

  /// No description provided for @habitLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Free limit reached'**
  String get habitLimitReached;

  /// No description provided for @upgradeToAddMore.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro for unlimited habits'**
  String get upgradeToAddMore;

  /// No description provided for @penaltyModeProTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro mode'**
  String get penaltyModeProTitle;

  /// No description provided for @penaltyModeProDescription.
  ///
  /// In en, this message translates to:
  /// **'Zen and Hardcore modes are available with Pro. Try different challenge levels!'**
  String get penaltyModeProDescription;

  /// No description provided for @reminderProTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro feature'**
  String get reminderProTitle;

  /// No description provided for @reminderProDescription.
  ///
  /// In en, this message translates to:
  /// **'Custom reminders for each habit are available with Pro. Never miss a day!'**
  String get reminderProDescription;

  /// No description provided for @themeProTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro theme'**
  String get themeProTitle;

  /// No description provided for @themeProDescription.
  ///
  /// In en, this message translates to:
  /// **'Light mode and future themes are available with Pro. Customize your experience!'**
  String get themeProDescription;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @proOnly.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proOnly;

  /// No description provided for @freeLimitedHistory.
  ///
  /// In en, this message translates to:
  /// **'Full history available with Pro'**
  String get freeLimitedHistory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
