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

  @override
  String get todayStatus => 'Statut du jour';

  @override
  String get correctToday => 'Corriger aujourd\'hui';

  @override
  String get todayValidated => 'Aujourd\'hui : Validé ✓';

  @override
  String get todaySkipped => 'Aujourd\'hui : Raté ✗';

  @override
  String get todayPending => 'Aujourd\'hui : En attente';

  @override
  String get markAsValidated => 'Marquer comme validé';

  @override
  String get markAsSkipped => 'Marquer comme raté';

  @override
  String get correctionWarning => 'Cette action va modifier ton streak';

  @override
  String get languageSection => 'Langue';

  @override
  String get aboutSection => 'À propos';

  @override
  String get dangerZone => 'Zone de danger';

  @override
  String get resetAllData => 'Réinitialiser les données';

  @override
  String get resetAllDataDescription =>
      'Supprimer toutes les habitudes et la progression';

  @override
  String get resetAllDataConfirm =>
      'Cela supprimera définitivement toutes vos habitudes et votre progression. Cette action est irréversible.';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get version => 'Version';

  @override
  String get appDescription => 'Construis ta base, jour après jour.';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get theme => 'Thème';

  @override
  String get supportSection => 'Support';

  @override
  String get sendFeedback => 'Envoyer un feedback';

  @override
  String get sendFeedbackDescription =>
      'Signaler un bug ou suggérer une amélioration';

  @override
  String get shareApp => 'Partager Moto';

  @override
  String get shareAppDescription => 'Recommander Moto à tes amis';

  @override
  String get shareMessage =>
      'Je construis de meilleures habitudes avec Moto ! Rejoins-moi et commence à bâtir ta base, jour après jour. 🧱';

  @override
  String get feedbackSubject => 'Feedback Moto';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDescription => 'Gérer les préférences de rappel';
}
