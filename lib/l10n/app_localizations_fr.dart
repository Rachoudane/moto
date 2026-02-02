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
}
