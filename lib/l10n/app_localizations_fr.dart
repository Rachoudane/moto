// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Moto';

  @override
  String get appSubtitle => '元';

  @override
  String get buildYourBase => 'Construis ta base';

  @override
  String get noHabits => 'Aucune habitude';

  @override
  String get noHabitsSubtitle => 'Commence à construire ta base';

  @override
  String get newHabit => 'Nouvelle habitude';

  @override
  String get habitName => 'Nom de l\'habitude';

  @override
  String get toDo => 'À faire';

  @override
  String get toQuit => 'À arrêter';

  @override
  String get penaltyMode => 'Mode de pénalité';

  @override
  String get zen => 'Zen';

  @override
  String get standard => 'Standard';

  @override
  String get hardcore => 'Hardcore';

  @override
  String get zenDescription => 'Perd 1 case en cas d\'échec';

  @override
  String get standardDescription => 'Perd le carré en cours en cas d\'échec';

  @override
  String get hardcoreDescription => 'Retour à zéro en cas d\'échec';

  @override
  String get create => 'Créer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get done => 'Fait';

  @override
  String get skipped => 'Passé';

  @override
  String get validated => '✓';

  @override
  String get deleteHabit => 'Supprimer cette habitude ?';

  @override
  String deleteHabitConfirm(int count) {
    return 'Tu vas perdre ta progression de $count cases.';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get editHabit => 'Modifier l\'habitude';

  @override
  String get currentProgress => 'Progression actuelle';

  @override
  String squareInProgress(int level) {
    return 'Carré $level×$level en cours';
  }

  @override
  String get totalCells => 'Cases totales';

  @override
  String completedSquares(int count) {
    return '$count carré(s) complété(s)';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get cells => 'cases';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get stop => 'STOP';

  @override
  String get history => 'Historique';

  @override
  String get statistics => 'Statistiques';

  @override
  String get currentStreak => 'Série actuelle';

  @override
  String get longestStreak => 'Meilleure série';

  @override
  String get successRate => 'Taux de réussite';

  @override
  String get bestDay => 'Meilleur jour';

  @override
  String get totalDays => 'Jours validés';

  @override
  String get days => 'jours';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get noDataYet => 'Pas encore de données';

  @override
  String get reminder => 'Rappel';

  @override
  String get reminderEnabled => 'Rappel quotidien';

  @override
  String get reminderTime => 'Heure du rappel';

  @override
  String reminderSet(String time) {
    return 'Rappel programmé à $time';
  }

  @override
  String get noReminder => 'Pas de rappel';

  @override
  String get permissionRequired => 'Permission de notification requise';

  @override
  String reminderBuildingMorning(String habit) {
    return 'Commence ta journée fort avec $habit';
  }

  @override
  String reminderBuildingAfternoon(String habit) {
    return 'Continue ! C\'est l\'heure de $habit';
  }

  @override
  String reminderBuildingEvening(String habit) {
    return 'Finis ta journée avec $habit';
  }

  @override
  String reminderQuittingMorning(String habit) {
    return 'Commence ta journée sans $habit';
  }

  @override
  String reminderQuittingAfternoon(String habit) {
    return 'Reste fort : résiste à $habit aujourd\'hui !';
  }

  @override
  String reminderQuittingEvening(String habit) {
    return 'Finis la journée fier : tu as évité $habit';
  }

  @override
  String reminderBeginnerGeneral(String habit) {
    return 'Tu débutes avec $habit - c\'est excellent !';
  }

  @override
  String reminderBeginnerMotivation(String habit) {
    return 'Les premiers pas comptent : c\'est $habit';
  }

  @override
  String reminderIntermediateGeneral(String habit) {
    return 'Regarde ta progression ! Continue avec $habit';
  }

  @override
  String reminderIntermediateMotivation(String habit) {
    return 'La dynamique est réelle : encore un jour de $habit';
  }

  @override
  String reminderAdvancedGeneral(String habit) {
    return 'Tu es un champion ! Garde ta série avec $habit';
  }

  @override
  String reminderAdvancedMotivation(String habit) {
    return 'La maîtrise t\'attend : encore un jour de $habit';
  }

  @override
  String reminderQuittingVictory(String habit) {
    return 'Chaque jour sans $habit est une victoire';
  }

  @override
  String reminderQuittingWillpower(String habit) {
    return 'Casse la chaîne avec $habit - tu peux !';
  }

  @override
  String reminderBuildingSuccess(String habit) {
    return 'Le succès vient de la constance : $habit';
  }

  @override
  String reminderBuildingFoundation(String habit) {
    return 'Construisons : c\'est l\'heure de $habit !';
  }

  @override
  String reminderBuildingMomentum(String habit) {
    return 'Tu es inarrêtable : fais $habit aujourd\'hui !';
  }
}
