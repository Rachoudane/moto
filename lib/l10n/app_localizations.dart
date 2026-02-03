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
  /// **'Lose 1 cell on failure'**
  String get zenDescription;

  /// No description provided for @standardDescription.
  ///
  /// In en, this message translates to:
  /// **'Lose current square on failure'**
  String get standardDescription;

  /// No description provided for @hardcoreDescription.
  ///
  /// In en, this message translates to:
  /// **'Back to zero on failure'**
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
