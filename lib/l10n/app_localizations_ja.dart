// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Moto';

  @override
  String get appSubtitle => '元';

  @override
  String get buildYourBase => '基盤を築こう';

  @override
  String get noHabits => '習慣がありません';

  @override
  String get noHabitsSubtitle => '基盤を築き始めよう';

  @override
  String get newHabit => '新しい習慣';

  @override
  String get habitName => '習慣の名前';

  @override
  String get toDo => 'やること';

  @override
  String get toQuit => 'やめること';

  @override
  String get penaltyMode => 'ペナルティモード';

  @override
  String get zen => '禅';

  @override
  String get standard => '普通';

  @override
  String get hardcore => '本気';

  @override
  String get zenDescription => '失敗で1マス失う';

  @override
  String get standardDescription => '失敗で現在の正方形を失う';

  @override
  String get hardcoreDescription => '失敗でゼロに戻る';

  @override
  String get create => '作成';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get done => '完了';

  @override
  String get skipped => 'スキップ';

  @override
  String get validated => '✓';

  @override
  String get deleteHabit => 'この習慣を削除しますか？';

  @override
  String deleteHabitConfirm(int count) {
    return '$countマスの進捗が失われます。';
  }

  @override
  String get delete => '削除';

  @override
  String get editHabit => '習慣を編集';

  @override
  String get currentProgress => '現在の進捗';

  @override
  String squareInProgress(int level) {
    return '$level×$levelの正方形進行中';
  }

  @override
  String get totalCells => '合計マス';

  @override
  String completedSquares(int count) {
    return '$count個の正方形完了';
  }

  @override
  String get settings => '設定';

  @override
  String get cells => 'マス';

  @override
  String get comingSoon => '近日公開';

  @override
  String get stop => 'STOP';

  @override
  String get history => '履歴';
}
