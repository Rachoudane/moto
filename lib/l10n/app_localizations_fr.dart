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
  String get zenDescription =>
      'Progression douce — un jour raté, seulement 1 point perdu. Idéal pour construire ses habitudes sans pression.';

  @override
  String get standardDescription =>
      'Défi équilibré — un jour raté, retour au niveau précédent. Motivant sans être trop sévère.';

  @override
  String get hardcoreDescription =>
      'Sans pitié — un jour raté, tout recommencer à zéro. Pour ceux qui aiment les défis extrêmes.';

  @override
  String get create => 'Créer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get done => 'Validé';

  @override
  String get skipped => 'Manqué';

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

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get onboardingTitle1 => '元 — L\'Origine';

  @override
  String get onboardingDesc1 =>
      'En japonais, 元 (Moto) signifie « origine » ou « fondement ». Chaque grande réussite commence par une seule action. Aujourd\'hui, tu poses la première pierre.';

  @override
  String get onboardingTitle2 => 'Construis, brique par brique';

  @override
  String get onboardingDesc2 =>
      'Pas de streak magique ici. Chaque jour validé ajoute une case à ton carré. 1×1, puis 2×2, puis 3×3... Tu visualises ta discipline prendre forme.';

  @override
  String get onboardingTitle3 => 'Tes victoires restent';

  @override
  String get onboardingDesc3 =>
      'Chaque carré complété devient un trophée doré — une preuve de ta constance. Même si tu trébuches, tes trophées restent. Tu ne repars jamais de zéro.';

  @override
  String get onboardingTitle4 => 'Choisis ton chemin';

  @override
  String get onboardingDesc4 =>
      '🌱 Zen : Progresse en douceur, perds une case.\n⚡ Standard : Perds le carré en cours.\n🔥 Hardcore : Recommence tout à zéro.';

  @override
  String get onboardingTitle5 => 'Va plus loin avec Pro';

  @override
  String get onboardingDesc5 =>
      'Débloque des habitudes illimitées, tous les modes, les rappels et plus encore. Ou commence gratuitement — tu peux améliorer à tout moment.';

  @override
  String get continueFree => 'Continuer gratuitement';

  @override
  String get replayOnboarding => 'Revoir l\'introduction';

  @override
  String errorGeneric(String message) {
    return 'Erreur : $message';
  }

  @override
  String get couldNotOpenEmail => 'Impossible d\'ouvrir le client email';

  @override
  String get unlockFullPotential => 'Libère tout ton potentiel';

  @override
  String get proDescription =>
      'Obtiens des habitudes illimitées, tous les modes de pénalité et des fonctionnalités puissantes pour construire des habitudes durables.';

  @override
  String get proFeature1 => 'Habitudes illimitées';

  @override
  String get proFeature2 =>
      'Tous les modes de pénalité (Zen, Standard, Hardcore)';

  @override
  String get proFeature3 => 'Historique complet et calendrier';

  @override
  String get proFeature4 => 'Notifications personnalisées par habitude';

  @override
  String get proFeature5 => 'Futures mises à jour et thèmes';

  @override
  String get yearly => 'Annuel';

  @override
  String get yearlySubtitle => 'Meilleur rapport';

  @override
  String get perMonth => '/mois';

  @override
  String savePercent(int percent) {
    return '-$percent%';
  }

  @override
  String get monthly => 'Mensuel';

  @override
  String get monthlySubtitle => 'Annule quand tu veux';

  @override
  String get lifetimeOffer => 'Accès à vie →';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get proActivated => 'Pro activé ! 🎉';

  @override
  String get noPurchasesFound => 'Aucun achat trouvé';

  @override
  String get habitLimitReached => 'Limite gratuite atteinte';

  @override
  String get upgradeToAddMore => 'Passe à Pro pour des habitudes illimitées';

  @override
  String get penaltyModeProTitle => 'Mode Pro';

  @override
  String get penaltyModeProDescription =>
      'Les modes Zen et Hardcore sont disponibles avec Pro. Essaie différents niveaux de défi !';

  @override
  String get reminderProTitle => 'Fonction Pro';

  @override
  String get reminderProDescription =>
      'Les rappels personnalisés par habitude sont disponibles avec Pro. Ne rate plus jamais un jour !';

  @override
  String get themeProTitle => 'Thème Pro';

  @override
  String get themeProDescription =>
      'Le mode clair et les futurs thèmes sont disponibles avec Pro. Personnalise ton expérience !';

  @override
  String get upgrade => 'Améliorer';

  @override
  String get proOnly => 'Pro';

  @override
  String get freeLimitedHistory => 'Historique complet disponible avec Pro';
}
