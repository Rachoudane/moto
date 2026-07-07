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
  /// **'No foundation yet.'**
  String get noHabits;

  /// No description provided for @noHabitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lay your first stone.'**
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

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @specificDays.
  ///
  /// In en, this message translates to:
  /// **'Specific days'**
  String get specificDays;

  /// No description provided for @restDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get restDay;

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

  /// No description provided for @penaltyRepairMessage.
  ///
  /// In en, this message translates to:
  /// **'The crack is repaired with gold. Let\'s keep building.'**
  String get penaltyRepairMessage;

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

  /// No description provided for @reorderHabit.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get reorderHabit;

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
  /// **'Meet Moto-san'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'元 means origin — the foundation. Every great achievement starts with a single action. Moto-san is here to build with you.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Every day lays a stone'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'No magic streaks. Each validated day adds a cell to your square. You literally watch your discipline take shape.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Stumbling is part of the path'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Miss a day? Moto-san repairs the crack with gold. Your completed trophies always remain — you never truly start from zero.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingModesHint.
  ///
  /// In en, this message translates to:
  /// **'🌱 Zen · ⚡ Standard · 🔥 Hardcore'**
  String get onboardingModesHint;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Your trophies remain'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Completed squares become permanent trophies. Earn badges, protect your streaks, build something that lasts.'**
  String get onboardingDesc4;

  /// No description provided for @onboardingFinalCta.
  ///
  /// In en, this message translates to:
  /// **'Lay your first stone'**
  String get onboardingFinalCta;

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

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get perMonth;

  /// No description provided for @savePercent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String savePercent(int percent);

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

  /// No description provided for @productNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Product not available. Try installing from Play Store or run in release mode.'**
  String get productNotAvailable;

  /// No description provided for @badgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badgesTitle;

  /// No description provided for @badgesUnlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} unlocked'**
  String badgesUnlockedCount(int count, int total);

  /// No description provided for @badgeUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'BADGE UNLOCKED'**
  String get badgeUnlockedTitle;

  /// No description provided for @badgeLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get badgeLockedTitle;

  /// No description provided for @badgeUnlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String badgeUnlockedOn(String date);

  /// No description provided for @badgeSecretLockedName.
  ///
  /// In en, this message translates to:
  /// **'???'**
  String get badgeSecretLockedName;

  /// No description provided for @badgeSecretLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Keep going — this one reveals itself when you earn it.'**
  String get badgeSecretLockedHint;

  /// No description provided for @badgeStreak7Name.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get badgeStreak7Name;

  /// No description provided for @badgeStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'Reached a 7-day streak on a habit.'**
  String get badgeStreak7Desc;

  /// No description provided for @badgeStreak30Name.
  ///
  /// In en, this message translates to:
  /// **'Momentum Builder'**
  String get badgeStreak30Name;

  /// No description provided for @badgeStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'Reached a 30-day streak. Real habits are forming.'**
  String get badgeStreak30Desc;

  /// No description provided for @badgeStreak100Name.
  ///
  /// In en, this message translates to:
  /// **'Centurion'**
  String get badgeStreak100Name;

  /// No description provided for @badgeStreak100Desc.
  ///
  /// In en, this message translates to:
  /// **'100 consecutive days. This is who you are now.'**
  String get badgeStreak100Desc;

  /// No description provided for @badgeStreak365Name.
  ///
  /// In en, this message translates to:
  /// **'Full Circle'**
  String get badgeStreak365Name;

  /// No description provided for @badgeStreak365Desc.
  ///
  /// In en, this message translates to:
  /// **'A full year, one day at a time.'**
  String get badgeStreak365Desc;

  /// No description provided for @badgeSquare1Name.
  ///
  /// In en, this message translates to:
  /// **'First Stone'**
  String get badgeSquare1Name;

  /// No description provided for @badgeSquare1Desc.
  ///
  /// In en, this message translates to:
  /// **'Completed your first 1×1 square.'**
  String get badgeSquare1Desc;

  /// No description provided for @badgeSquare2Name.
  ///
  /// In en, this message translates to:
  /// **'Foundation Laid'**
  String get badgeSquare2Name;

  /// No description provided for @badgeSquare2Desc.
  ///
  /// In en, this message translates to:
  /// **'Completed a 2×2 square.'**
  String get badgeSquare2Desc;

  /// No description provided for @badgeSquare3Name.
  ///
  /// In en, this message translates to:
  /// **'Building Up'**
  String get badgeSquare3Name;

  /// No description provided for @badgeSquare3Desc.
  ///
  /// In en, this message translates to:
  /// **'Completed a 3×3 square.'**
  String get badgeSquare3Desc;

  /// No description provided for @badgeSquare5Name.
  ///
  /// In en, this message translates to:
  /// **'Architect'**
  String get badgeSquare5Name;

  /// No description provided for @badgeSquare5Desc.
  ///
  /// In en, this message translates to:
  /// **'Completed a 5×5 square.'**
  String get badgeSquare5Desc;

  /// No description provided for @badgeSquare8Name.
  ///
  /// In en, this message translates to:
  /// **'Master Builder'**
  String get badgeSquare8Name;

  /// No description provided for @badgeSquare8Desc.
  ///
  /// In en, this message translates to:
  /// **'Completed an 8×8 square.'**
  String get badgeSquare8Desc;

  /// No description provided for @badgeCells10Name.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get badgeCells10Name;

  /// No description provided for @badgeCells10Desc.
  ///
  /// In en, this message translates to:
  /// **'10 total validated days across all habits.'**
  String get badgeCells10Desc;

  /// No description provided for @badgeCells50Name.
  ///
  /// In en, this message translates to:
  /// **'Steady Hands'**
  String get badgeCells50Name;

  /// No description provided for @badgeCells50Desc.
  ///
  /// In en, this message translates to:
  /// **'50 total validated days.'**
  String get badgeCells50Desc;

  /// No description provided for @badgeCells100Name.
  ///
  /// In en, this message translates to:
  /// **'Century Club'**
  String get badgeCells100Name;

  /// No description provided for @badgeCells100Desc.
  ///
  /// In en, this message translates to:
  /// **'100 total validated days.'**
  String get badgeCells100Desc;

  /// No description provided for @badgeCells500Name.
  ///
  /// In en, this message translates to:
  /// **'Iron Will'**
  String get badgeCells500Name;

  /// No description provided for @badgeCells500Desc.
  ///
  /// In en, this message translates to:
  /// **'500 total validated days.'**
  String get badgeCells500Desc;

  /// No description provided for @badgeCells1000Name.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get badgeCells1000Name;

  /// No description provided for @badgeCells1000Desc.
  ///
  /// In en, this message translates to:
  /// **'1000 total validated days. Extraordinary.'**
  String get badgeCells1000Desc;

  /// No description provided for @badgeHabits3Name.
  ///
  /// In en, this message translates to:
  /// **'Multitasker'**
  String get badgeHabits3Name;

  /// No description provided for @badgeHabits3Desc.
  ///
  /// In en, this message translates to:
  /// **'Tracking 3 habits at once.'**
  String get badgeHabits3Desc;

  /// No description provided for @badgeHabits5Name.
  ///
  /// In en, this message translates to:
  /// **'Juggler'**
  String get badgeHabits5Name;

  /// No description provided for @badgeHabits5Desc.
  ///
  /// In en, this message translates to:
  /// **'Tracking 5 habits at once.'**
  String get badgeHabits5Desc;

  /// No description provided for @badgeHabits10Name.
  ///
  /// In en, this message translates to:
  /// **'Habit Collector'**
  String get badgeHabits10Name;

  /// No description provided for @badgeHabits10Desc.
  ///
  /// In en, this message translates to:
  /// **'Tracking 10 habits at once.'**
  String get badgeHabits10Desc;

  /// No description provided for @badgeEarlyBirdName.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get badgeEarlyBirdName;

  /// No description provided for @badgeEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Validated a habit before 7am.'**
  String get badgeEarlyBirdDesc;

  /// No description provided for @badgeNightOwlName.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get badgeNightOwlName;

  /// No description provided for @badgeNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Validated a habit at 10pm or later.'**
  String get badgeNightOwlDesc;

  /// No description provided for @badgeWeekendWarriorName.
  ///
  /// In en, this message translates to:
  /// **'Weekend Warrior'**
  String get badgeWeekendWarriorName;

  /// No description provided for @badgeWeekendWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Stayed consistent on both Saturday and Sunday.'**
  String get badgeWeekendWarriorDesc;

  /// No description provided for @badgeComebackName.
  ///
  /// In en, this message translates to:
  /// **'The Comeback'**
  String get badgeComebackName;

  /// No description provided for @badgeComebackDesc.
  ///
  /// In en, this message translates to:
  /// **'Returned and validated after missing 3+ days in a row.'**
  String get badgeComebackDesc;

  /// No description provided for @badgePerfectWeekName.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get badgePerfectWeekName;

  /// No description provided for @badgePerfectWeekDesc.
  ///
  /// In en, this message translates to:
  /// **'7 days in a row, zero misses.'**
  String get badgePerfectWeekDesc;

  /// No description provided for @badgePerfectMonthName.
  ///
  /// In en, this message translates to:
  /// **'Perfect Month'**
  String get badgePerfectMonthName;

  /// No description provided for @badgePerfectMonthDesc.
  ///
  /// In en, this message translates to:
  /// **'30 days in a row, zero misses.'**
  String get badgePerfectMonthDesc;

  /// No description provided for @badgeHardcoreSurvivorName.
  ///
  /// In en, this message translates to:
  /// **'Hardcore Survivor'**
  String get badgeHardcoreSurvivorName;

  /// No description provided for @badgeHardcoreSurvivorDesc.
  ///
  /// In en, this message translates to:
  /// **'Survived 30 days on Hardcore mode without a reset.'**
  String get badgeHardcoreSurvivorDesc;

  /// No description provided for @badgeZenMasterName.
  ///
  /// In en, this message translates to:
  /// **'Zen Master'**
  String get badgeZenMasterName;

  /// No description provided for @badgeZenMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'100 validated days on Zen mode.'**
  String get badgeZenMasterDesc;

  /// No description provided for @badgeSecretPerfectionistName.
  ///
  /// In en, this message translates to:
  /// **'The Perfectionist'**
  String get badgeSecretPerfectionistName;

  /// No description provided for @badgeSecretPerfectionistDesc.
  ///
  /// In en, this message translates to:
  /// **'Never missed a single day across 20+ entries.'**
  String get badgeSecretPerfectionistDesc;

  /// No description provided for @badgeSecretMultitaskerName.
  ///
  /// In en, this message translates to:
  /// **'Five-Ring Focus'**
  String get badgeSecretMultitaskerName;

  /// No description provided for @badgeSecretMultitaskerDesc.
  ///
  /// In en, this message translates to:
  /// **'Kept 5 habits alive with an active streak at the same time.'**
  String get badgeSecretMultitaskerDesc;

  /// No description provided for @shareMyProgress.
  ///
  /// In en, this message translates to:
  /// **'Share my progress'**
  String get shareMyProgress;

  /// No description provided for @shareFindOnAppStore.
  ///
  /// In en, this message translates to:
  /// **'Search \"Moto\" on the App Store.'**
  String get shareFindOnAppStore;

  /// No description provided for @shareAppMsg1.
  ///
  /// In en, this message translates to:
  /// **'I\'m building better habits with Moto — one square at a time. 🧱 Come build yours.'**
  String get shareAppMsg1;

  /// No description provided for @shareAppMsg2.
  ///
  /// In en, this message translates to:
  /// **'Found an app that actually makes habits stick: Moto. Turns your consistency into visual progress. 🌱'**
  String get shareAppMsg2;

  /// No description provided for @shareAppMsg3.
  ///
  /// In en, this message translates to:
  /// **'Moto turned my daily habits into something I can actually see grow. Try it. 元'**
  String get shareAppMsg3;

  /// No description provided for @shareAppMsg4.
  ///
  /// In en, this message translates to:
  /// **'No streak-shaming, just squares that grow with you. Moto is worth a look. 🧩'**
  String get shareAppMsg4;

  /// No description provided for @shareAppMsg5.
  ///
  /// In en, this message translates to:
  /// **'I\'ve been building my foundation, one validated day at a time, with Moto. Join me?'**
  String get shareAppMsg5;

  /// No description provided for @shareAppMsg6.
  ///
  /// In en, this message translates to:
  /// **'This habit tracker made consistency feel like a game I actually want to win. Moto. 🏆'**
  String get shareAppMsg6;

  /// No description provided for @shareAppMsg7.
  ///
  /// In en, this message translates to:
  /// **'Small daily actions, visualized as growing squares. That\'s Moto — give it a shot.'**
  String get shareAppMsg7;

  /// No description provided for @shareProgressMsg1.
  ///
  /// In en, this message translates to:
  /// **'{streak} cells and counting on \"{habitName}\" with Moto. Building my foundation, one day at a time. 🧱'**
  String shareProgressMsg1(String habitName, int streak);

  /// No description provided for @shareProgressMsg2.
  ///
  /// In en, this message translates to:
  /// **'Day by day, \"{habitName}\" is turning into something real — {streak} cells so far on Moto. 🌱'**
  String shareProgressMsg2(String habitName, int streak);

  /// No description provided for @shareProgressMsg3.
  ///
  /// In en, this message translates to:
  /// **'{streak} validated days on \"{habitName}\". Moto is keeping me honest. 元'**
  String shareProgressMsg3(String habitName, int streak);

  /// No description provided for @shareProgressMsg4.
  ///
  /// In en, this message translates to:
  /// **'Watching \"{habitName}\" grow square by square — {streak} cells in on Moto.'**
  String shareProgressMsg4(String habitName, int streak);

  /// No description provided for @shareProgressMsg5.
  ///
  /// In en, this message translates to:
  /// **'My \"{habitName}\" streak just hit {streak} cells on Moto. Small steps, real progress.'**
  String shareProgressMsg5(String habitName, int streak);

  /// No description provided for @shareBadgeMsg1.
  ///
  /// In en, this message translates to:
  /// **'Just unlocked the \"{badgeName}\" badge on Moto! 🏆'**
  String shareBadgeMsg1(String badgeName);

  /// No description provided for @shareBadgeMsg2.
  ///
  /// In en, this message translates to:
  /// **'New trophy unlocked: \"{badgeName}\" on Moto. Feels good. 元'**
  String shareBadgeMsg2(String badgeName);

  /// No description provided for @shareBadgeMsg3.
  ///
  /// In en, this message translates to:
  /// **'Consistency paid off — earned the \"{badgeName}\" badge on Moto!'**
  String shareBadgeMsg3(String badgeName);

  /// No description provided for @shareBadgeMsg4.
  ///
  /// In en, this message translates to:
  /// **'\"{badgeName}\" — unlocked on Moto. One more proof the small stuff adds up.'**
  String shareBadgeMsg4(String badgeName);

  /// No description provided for @shareBadgeMsg5.
  ///
  /// In en, this message translates to:
  /// **'Moto just gave me the \"{badgeName}\" badge. Onward. 🌱'**
  String shareBadgeMsg5(String badgeName);

  /// No description provided for @shareSquareMsg1.
  ///
  /// In en, this message translates to:
  /// **'Just completed a {level}×{level} square on \"{habitName}\" with Moto! 🧱'**
  String shareSquareMsg1(String habitName, int level);

  /// No description provided for @shareSquareMsg2.
  ///
  /// In en, this message translates to:
  /// **'\"{habitName}\" leveled up — {level}×{level} square complete on Moto.'**
  String shareSquareMsg2(String habitName, int level);

  /// No description provided for @shareSquareMsg3.
  ///
  /// In en, this message translates to:
  /// **'Another trophy earned: {level}×{level} on \"{habitName}\". Moto keeps the proof. 元'**
  String shareSquareMsg3(String habitName, int level);

  /// No description provided for @shareSquareMsg4.
  ///
  /// In en, this message translates to:
  /// **'Square complete! {level}×{level} on \"{habitName}\" — built one validated day at a time.'**
  String shareSquareMsg4(String habitName, int level);

  /// No description provided for @shareSquareMsg5.
  ///
  /// In en, this message translates to:
  /// **'\"{habitName}\" just hit a {level}×{level} square on Moto. Consistency, visualized.'**
  String shareSquareMsg5(String habitName, int level);

  /// No description provided for @squareCompletedCelebration.
  ///
  /// In en, this message translates to:
  /// **'🎉 Square completed! You just finished a {count}×{count}.'**
  String squareCompletedCelebration(int count);

  /// No description provided for @streakMilestoneCelebration.
  ///
  /// In en, this message translates to:
  /// **'🔥 {streak}-day streak! Keep the momentum going.'**
  String streakMilestoneCelebration(int streak);

  /// No description provided for @proDowngradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Pro subscription has ended'**
  String get proDowngradeTitle;

  /// No description provided for @proDowngradeDescription.
  ///
  /// In en, this message translates to:
  /// **'No worries — all your habits and history are safe. You\'re back on the free plan for now. Resubscribe anytime to unlock everything again.'**
  String get proDowngradeDescription;

  /// No description provided for @proPromoCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Go further with Pro'**
  String get proPromoCardTitle;

  /// No description provided for @proPromoCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited habits, full history, and more.'**
  String get proPromoCardSubtitle;

  /// No description provided for @proSocialProof.
  ///
  /// In en, this message translates to:
  /// **'Join thousands building better habits with Moto Pro'**
  String get proSocialProof;

  /// No description provided for @editHistoryProTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit full history'**
  String get editHistoryProTitle;

  /// No description provided for @editHistoryProDescription.
  ///
  /// In en, this message translates to:
  /// **'Editing dates older than 7 days is available with Pro. Free accounts can correct the last week.'**
  String get editHistoryProDescription;

  /// No description provided for @clearDay.
  ///
  /// In en, this message translates to:
  /// **'Clear this day'**
  String get clearDay;

  /// No description provided for @dailyQuoteNotification.
  ///
  /// In en, this message translates to:
  /// **'Daily quote'**
  String get dailyQuoteNotification;

  /// No description provided for @dailyQuoteNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'One motivational thought every morning at 8:00, free for everyone'**
  String get dailyQuoteNotificationDescription;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get quietHours;

  /// No description provided for @quietHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders won\'t be sent during this window'**
  String get quietHoursDescription;

  /// No description provided for @quietHoursStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get quietHoursStart;

  /// No description provided for @quietHoursEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get quietHoursEnd;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get sendTestNotification;

  /// No description provided for @sendTestNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Verify your reminders are working correctly'**
  String get sendTestNotificationDescription;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'This is a test notification from Moto. If you can see this, reminders are working! 🔔'**
  String get testNotificationBody;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// No description provided for @reminderGentle1.
  ///
  /// In en, this message translates to:
  /// **'No pressure — just {habit}, whenever you\'re ready today.'**
  String reminderGentle1(String habit);

  /// No description provided for @reminderGentle2.
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge: {habit} is waiting for you.'**
  String reminderGentle2(String habit);

  /// No description provided for @reminderGentle3.
  ///
  /// In en, this message translates to:
  /// **'Whenever you get a moment today, {habit} would love the attention.'**
  String reminderGentle3(String habit);

  /// No description provided for @reminderPlayful1.
  ///
  /// In en, this message translates to:
  /// **'Psst. {habit} called. It misses you.'**
  String reminderPlayful1(String habit);

  /// No description provided for @reminderPlayful2.
  ///
  /// In en, this message translates to:
  /// **'Your square is waiting to grow. Feed it some {habit} today.'**
  String reminderPlayful2(String habit);

  /// No description provided for @reminderPlayful3.
  ///
  /// In en, this message translates to:
  /// **'Plot twist: today is a great day for {habit}.'**
  String reminderPlayful3(String habit);

  /// No description provided for @reminderWeekendVibe.
  ///
  /// In en, this message translates to:
  /// **'Weekend or not, {habit} doesn\'t take days off.'**
  String reminderWeekendVibe(String habit);

  /// No description provided for @reminderStreakMilestone.
  ///
  /// In en, this message translates to:
  /// **'{streak} days strong on {habit}. Don\'t stop now.'**
  String reminderStreakMilestone(String habit, int streak);
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
