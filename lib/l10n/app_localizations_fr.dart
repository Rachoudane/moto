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
  String get frequency => 'Fréquence';

  @override
  String get everyDay => 'Tous les jours';

  @override
  String get specificDays => 'Jours spécifiques';

  @override
  String get restDay => 'Jour de repos';

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
  String get reorderHabit => 'Glisser pour réorganiser';

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

  @override
  String get productNotAvailable =>
      'Produit non disponible. Essayez d\'installer depuis le Play Store ou lancez en mode release.';

  @override
  String get badgesTitle => 'Badges';

  @override
  String badgesUnlockedCount(int count, int total) {
    return '$count sur $total débloqués';
  }

  @override
  String get badgeUnlockedTitle => 'BADGE DÉBLOQUÉ';

  @override
  String get badgeLockedTitle => 'VERROUILLÉ';

  @override
  String badgeUnlockedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String get badgeSecretLockedName => '???';

  @override
  String get badgeSecretLockedHint =>
      'Continue — celui-ci se révèle quand tu le mérites.';

  @override
  String get badgeStreak7Name => 'Guerrier de la semaine';

  @override
  String get badgeStreak7Desc =>
      'Tu as atteint une série de 7 jours sur une habitude.';

  @override
  String get badgeStreak30Name => 'Bâtisseur d\'élan';

  @override
  String get badgeStreak30Desc =>
      'Série de 30 jours atteinte. De vraies habitudes se forment.';

  @override
  String get badgeStreak100Name => 'Centurion';

  @override
  String get badgeStreak100Desc =>
      '100 jours consécutifs. C\'est qui tu es maintenant.';

  @override
  String get badgeStreak365Name => 'Boucle complète';

  @override
  String get badgeStreak365Desc => 'Une année entière, un jour à la fois.';

  @override
  String get badgeSquare1Name => 'Première pierre';

  @override
  String get badgeSquare1Desc => 'Tu as complété ton premier carré 1×1.';

  @override
  String get badgeSquare2Name => 'Fondation posée';

  @override
  String get badgeSquare2Desc => 'Carré 2×2 complété.';

  @override
  String get badgeSquare3Name => 'En construction';

  @override
  String get badgeSquare3Desc => 'Carré 3×3 complété.';

  @override
  String get badgeSquare5Name => 'Architecte';

  @override
  String get badgeSquare5Desc => 'Carré 5×5 complété.';

  @override
  String get badgeSquare8Name => 'Maître bâtisseur';

  @override
  String get badgeSquare8Desc => 'Carré 8×8 complété.';

  @override
  String get badgeCells10Name => 'Premiers pas';

  @override
  String get badgeCells10Desc =>
      '10 jours validés au total, toutes habitudes confondues.';

  @override
  String get badgeCells50Name => 'Mains sûres';

  @override
  String get badgeCells50Desc => '50 jours validés au total.';

  @override
  String get badgeCells100Name => 'Club du siècle';

  @override
  String get badgeCells100Desc => '100 jours validés au total.';

  @override
  String get badgeCells500Name => 'Volonté de fer';

  @override
  String get badgeCells500Desc => '500 jours validés au total.';

  @override
  String get badgeCells1000Name => 'Légende';

  @override
  String get badgeCells1000Desc =>
      '1000 jours validés au total. Extraordinaire.';

  @override
  String get badgeHabits3Name => 'Multitâche';

  @override
  String get badgeHabits3Desc => '3 habitudes suivies en même temps.';

  @override
  String get badgeHabits5Name => 'Jongleur';

  @override
  String get badgeHabits5Desc => '5 habitudes suivies en même temps.';

  @override
  String get badgeHabits10Name => 'Collectionneur d\'habitudes';

  @override
  String get badgeHabits10Desc => '10 habitudes suivies en même temps.';

  @override
  String get badgeEarlyBirdName => 'Lève-tôt';

  @override
  String get badgeEarlyBirdDesc => 'Habitude validée avant 7h du matin.';

  @override
  String get badgeNightOwlName => 'Oiseau de nuit';

  @override
  String get badgeNightOwlDesc => 'Habitude validée à 22h ou plus tard.';

  @override
  String get badgeWeekendWarriorName => 'Guerrier du week-end';

  @override
  String get badgeWeekendWarriorDesc => 'Constant le samedi et le dimanche.';

  @override
  String get badgeComebackName => 'Le retour';

  @override
  String get badgeComebackDesc =>
      'De retour après 3 jours ratés ou plus d\'affilée.';

  @override
  String get badgePerfectWeekName => 'Semaine parfaite';

  @override
  String get badgePerfectWeekDesc => '7 jours d\'affilée, zéro raté.';

  @override
  String get badgePerfectMonthName => 'Mois parfait';

  @override
  String get badgePerfectMonthDesc => '30 jours d\'affilée, zéro raté.';

  @override
  String get badgeHardcoreSurvivorName => 'Survivant Hardcore';

  @override
  String get badgeHardcoreSurvivorDesc =>
      '30 jours en mode Hardcore sans réinitialisation.';

  @override
  String get badgeZenMasterName => 'Maître zen';

  @override
  String get badgeZenMasterDesc => '100 jours validés en mode Zen.';

  @override
  String get badgeSecretPerfectionistName => 'Le perfectionniste';

  @override
  String get badgeSecretPerfectionistDesc =>
      'Jamais raté un seul jour sur plus de 20 entrées.';

  @override
  String get badgeSecretMultitaskerName => 'Concentration des cinq anneaux';

  @override
  String get badgeSecretMultitaskerDesc =>
      '5 habitudes actives en série au même moment.';

  @override
  String get shareMyProgress => 'Partager ma progression';

  @override
  String get shareFindOnAppStore => 'Cherche « Moto » sur l\'App Store.';

  @override
  String get shareAppMsg1 =>
      'Je construis de meilleures habitudes avec Moto — une case à la fois. 🧱 Viens construire les tiennes.';

  @override
  String get shareAppMsg2 =>
      'J\'ai trouvé une appli qui rend les habitudes vraiment durables : Moto. Elle transforme ta régularité en progrès visuel. 🌱';

  @override
  String get shareAppMsg3 =>
      'Moto a transformé mes habitudes quotidiennes en quelque chose que je vois vraiment grandir. Essaie-la. 元';

  @override
  String get shareAppMsg4 =>
      'Pas de culpabilisation sur les séries ratées, juste des carrés qui grandissent avec toi. Moto vaut le détour. 🧩';

  @override
  String get shareAppMsg5 =>
      'Je construis ma base, un jour validé à la fois, avec Moto. Tu me rejoins ?';

  @override
  String get shareAppMsg6 =>
      'Ce tracker d\'habitudes a transformé la régularité en jeu que j\'ai vraiment envie de gagner. Moto. 🏆';

  @override
  String get shareAppMsg7 =>
      'De petites actions quotidiennes, visualisées en carrés qui grandissent. Voilà Moto — tente le coup.';

  @override
  String shareProgressMsg1(String habitName, int streak) {
    return '$streak cases et ça continue sur « $habitName » avec Moto. Je construis ma base, un jour à la fois. 🧱';
  }

  @override
  String shareProgressMsg2(String habitName, int streak) {
    return 'Jour après jour, « $habitName » devient concret — $streak cases jusqu\'ici sur Moto. 🌱';
  }

  @override
  String shareProgressMsg3(String habitName, int streak) {
    return '$streak jours validés sur « $habitName ». Moto me garde honnête. 元';
  }

  @override
  String shareProgressMsg4(String habitName, int streak) {
    return 'Je regarde « $habitName » grandir case par case — $streak cases sur Moto.';
  }

  @override
  String shareProgressMsg5(String habitName, int streak) {
    return 'Ma série sur « $habitName » vient d\'atteindre $streak cases avec Moto. Petits pas, vrais progrès.';
  }

  @override
  String shareBadgeMsg1(String badgeName) {
    return 'Je viens de débloquer le badge « $badgeName » sur Moto ! 🏆';
  }

  @override
  String shareBadgeMsg2(String badgeName) {
    return 'Nouveau trophée débloqué : « $badgeName » sur Moto. Ça fait du bien. 元';
  }

  @override
  String shareBadgeMsg3(String badgeName) {
    return 'La régularité a payé — badge « $badgeName » obtenu sur Moto !';
  }

  @override
  String shareBadgeMsg4(String badgeName) {
    return '« $badgeName » — débloqué sur Moto. Une preuve de plus que les petites choses s\'additionnent.';
  }

  @override
  String shareBadgeMsg5(String badgeName) {
    return 'Moto vient de me donner le badge « $badgeName ». On continue. 🌱';
  }

  @override
  String shareSquareMsg1(String habitName, int level) {
    return 'Je viens de compléter un carré $level×$level sur « $habitName » avec Moto ! 🧱';
  }

  @override
  String shareSquareMsg2(String habitName, int level) {
    return '« $habitName » a franchi un cap — carré $level×$level complété sur Moto.';
  }

  @override
  String shareSquareMsg3(String habitName, int level) {
    return 'Un trophée de plus : $level×$level sur « $habitName ». Moto garde la preuve. 元';
  }

  @override
  String shareSquareMsg4(String habitName, int level) {
    return 'Carré complété ! $level×$level sur « $habitName » — construit un jour validé à la fois.';
  }

  @override
  String shareSquareMsg5(String habitName, int level) {
    return '« $habitName » vient d\'atteindre un carré $level×$level sur Moto. La régularité, visualisée.';
  }

  @override
  String squareCompletedCelebration(int count) {
    return '🎉 Carré complété ! Tu viens de terminer un $count×$count.';
  }

  @override
  String streakMilestoneCelebration(int streak) {
    return '🔥 Série de $streak jours ! Garde l\'élan.';
  }

  @override
  String get proDowngradeTitle => 'Ton abonnement Pro a pris fin';

  @override
  String get proDowngradeDescription =>
      'Pas de souci — toutes tes habitudes et ton historique sont en sécurité. Tu es de retour sur le plan gratuit pour l\'instant. Réabonne-toi quand tu veux pour tout redébloquer.';

  @override
  String get proPromoCardTitle => 'Va plus loin avec Pro';

  @override
  String get proPromoCardSubtitle =>
      'Habitudes illimitées, historique complet, et plus.';

  @override
  String get proSocialProof =>
      'Rejoins des milliers de personnes qui construisent de meilleures habitudes avec Moto Pro';

  @override
  String get editHistoryProTitle => 'Modifier tout l\'historique';

  @override
  String get editHistoryProDescription =>
      'Modifier des dates de plus de 7 jours est disponible avec Pro. Les comptes gratuits peuvent corriger la dernière semaine.';

  @override
  String get clearDay => 'Effacer ce jour';

  @override
  String get dailyQuoteNotification => 'Citation du jour';

  @override
  String get dailyQuoteNotificationDescription =>
      'Une pensée motivante chaque matin à 8h00, gratuit pour tous';

  @override
  String get quietHours => 'Heures silencieuses';

  @override
  String get quietHoursDescription =>
      'Les rappels ne seront pas envoyés pendant cette période';

  @override
  String get quietHoursStart => 'Début';

  @override
  String get quietHoursEnd => 'Fin';

  @override
  String get sendTestNotification => 'Envoyer une notification test';

  @override
  String get sendTestNotificationDescription =>
      'Vérifie que tes rappels fonctionnent correctement';

  @override
  String get testNotificationBody =>
      'Ceci est une notification test de Moto. Si tu la vois, les rappels fonctionnent ! 🔔';

  @override
  String get testNotificationSent => 'Notification test envoyée';

  @override
  String reminderGentle1(String habit) {
    return 'Pas de pression — juste $habit, quand tu es prêt aujourd\'hui.';
  }

  @override
  String reminderGentle2(String habit) {
    return 'Un petit rappel en douceur : $habit t\'attend.';
  }

  @override
  String reminderGentle3(String habit) {
    return 'Quand tu auras un moment aujourd\'hui, $habit mérite ton attention.';
  }

  @override
  String reminderPlayful1(String habit) {
    return 'Psst. $habit a appelé. Ça lui manque.';
  }

  @override
  String reminderPlayful2(String habit) {
    return 'Ton carré attend de grandir. Nourris-le avec un peu de $habit aujourd\'hui.';
  }

  @override
  String reminderPlayful3(String habit) {
    return 'Coup de théâtre : aujourd\'hui est un jour parfait pour $habit.';
  }

  @override
  String reminderWeekendVibe(String habit) {
    return 'Week-end ou pas, $habit ne prend pas de jour de repos.';
  }

  @override
  String reminderStreakMilestone(String habit, int streak) {
    return '$streak jours solides sur $habit. N\'arrête pas maintenant.';
  }
}
