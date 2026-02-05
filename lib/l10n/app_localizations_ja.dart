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

  @override
  String get statistics => '統計';

  @override
  String get currentStreak => '現在の連続';

  @override
  String get longestStreak => '最長連続';

  @override
  String get successRate => '成功率';

  @override
  String get bestDay => 'ベストな曜日';

  @override
  String get totalDays => '達成日数';

  @override
  String get days => '日';

  @override
  String get monday => '月曜日';

  @override
  String get tuesday => '火曜日';

  @override
  String get wednesday => '水曜日';

  @override
  String get thursday => '木曜日';

  @override
  String get friday => '金曜日';

  @override
  String get saturday => '土曜日';

  @override
  String get sunday => '日曜日';

  @override
  String get noDataYet => 'まだデータがありません';

  @override
  String get reminder => 'リマインダー';

  @override
  String get reminderEnabled => '毎日のリマインダー';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String reminderSet(String time) {
    return '$timeにリマインダー設定';
  }

  @override
  String get noReminder => 'リマインダーなし';

  @override
  String get permissionRequired => '通知の許可が必要です';

  @override
  String reminderBuildingMorning(String habit) {
    return '朝から力強く$habitをしよう';
  }

  @override
  String reminderBuildingAfternoon(String habit) {
    return '続けよう！$habitの時間だ';
  }

  @override
  String reminderBuildingEvening(String habit) {
    return '一日の終わりに$habitをしよう';
  }

  @override
  String reminderQuittingMorning(String habit) {
    return '朝から$habitなしで始めよう';
  }

  @override
  String reminderQuittingAfternoon(String habit) {
    return '$habitに抵抗し続けよう！';
  }

  @override
  String reminderQuittingEvening(String habit) {
    return '$habitを避けた誇りある夜';
  }

  @override
  String reminderBeginnerGeneral(String habit) {
    return '$habitを始めたばかり - 素晴らしい！';
  }

  @override
  String reminderBeginnerMotivation(String habit) {
    return '第一歩が大切：$habitをしよう';
  }

  @override
  String reminderIntermediateGeneral(String habit) {
    return '自分の進捗を見よう！$habitを続けよう';
  }

  @override
  String reminderIntermediateMotivation(String habit) {
    return '勢いは本物だ：さらに一日の$habit';
  }

  @override
  String reminderAdvancedGeneral(String habit) {
    return '君はチャンピオンだ！$habitで記録を保ちよう';
  }

  @override
  String reminderAdvancedMotivation(String habit) {
    return '熟練へ向かおう：さらに一日の$habit';
  }

  @override
  String reminderQuittingVictory(String habit) {
    return '$habitのない毎日が勝利だ';
  }

  @override
  String reminderQuittingWillpower(String habit) {
    return '$habitとの関係を断ち切ろう - 君なら出来る！';
  }

  @override
  String reminderBuildingSuccess(String habit) {
    return '成功は継続から来る：$habit';
  }

  @override
  String reminderBuildingFoundation(String habit) {
    return '$habitの時間だ！基盤を築こう！';
  }

  @override
  String reminderBuildingMomentum(String habit) {
    return '君は止められない！$habitをしよう';
  }

  @override
  String get todayStatus => '今日のステータス';

  @override
  String get correctToday => '今日を修正';

  @override
  String get todayValidated => '今日：達成 ✓';

  @override
  String get todaySkipped => '今日：失敗 ✗';

  @override
  String get todayPending => '今日：未定';

  @override
  String get markAsValidated => '達成にする';

  @override
  String get markAsSkipped => '失敗にする';

  @override
  String get correctionWarning => 'この操作は連続記録を変更します';

  @override
  String get languageSection => '言語';

  @override
  String get aboutSection => 'アプリについて';

  @override
  String get dangerZone => '危険ゾーン';

  @override
  String get resetAllData => 'すべてのデータをリセット';

  @override
  String get resetAllDataDescription => 'すべての習慣と進捗を完全に削除';

  @override
  String get resetAllDataConfirm => 'すべての習慣と進捗が完全に削除されます。この操作は元に戻せません。';

  @override
  String get reset => 'リセット';

  @override
  String get version => 'バージョン';

  @override
  String get appDescription => '毎日、基盤を築こう。';

  @override
  String get appearanceSection => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get lightMode => 'ライトモード';

  @override
  String get theme => 'テーマ';

  @override
  String get supportSection => 'サポート';

  @override
  String get sendFeedback => 'フィードバックを送る';

  @override
  String get sendFeedbackDescription => 'バグを報告するか改善を提案する';

  @override
  String get shareApp => 'Motoをシェア';

  @override
  String get shareAppDescription => '友達にMotoをおすすめする';

  @override
  String get shareMessage => 'Motoでより良い習慣を築いています！一緒に始めて、毎日基盤を築こう。🧱';

  @override
  String get feedbackSubject => 'Motoフィードバック';

  @override
  String get notifications => '通知';

  @override
  String get notificationsDescription => 'リマインダー設定を管理する';

  @override
  String get skip => 'スキップ';

  @override
  String get next => '次へ';

  @override
  String get getStarted => '始める';

  @override
  String get onboardingTitle1 => '元 — 始まり';

  @override
  String get onboardingDesc1 =>
      '「元」は起源、基盤を意味します。すべての偉大な成果は、たった一つの行動から始まります。今日、最初の石を置こう。';

  @override
  String get onboardingTitle2 => '一歩ずつ、積み上げる';

  @override
  String get onboardingDesc2 =>
      '魔法のストリークはありません。毎日の達成がマスを増やします。1×1、2×2、3×3…自分の規律が形になるのを見届けよう。';

  @override
  String get onboardingTitle3 => '勝利は残る';

  @override
  String get onboardingDesc3 =>
      '完成した正方形は金色のトロフィーになります。つまずいても、トロフィーは消えません。ゼロからやり直すことはありません。';

  @override
  String get onboardingTitle4 => '自分の道を選ぶ';

  @override
  String get onboardingDesc4 =>
      '🌱 禅：優しく進む、1マス失う。\n⚡ 普通：現在の正方形を失う。\n🔥 本気：完全にゼロから。';

  @override
  String get replayOnboarding => '紹介を再生';

  @override
  String errorGeneric(String message) {
    return 'エラー：$message';
  }

  @override
  String get couldNotOpenEmail => 'メールアプリを開けませんでした';

  @override
  String get unlockFullPotential => '全ての可能性を解放';

  @override
  String get proDescription =>
      '無制限の習慣、すべてのペナルティモード、そして持続する習慣を築くための強力な機能を手に入れよう。';

  @override
  String get proFeature1 => '無制限の習慣';

  @override
  String get proFeature2 => 'すべてのペナルティモード（禅、普通、本気）';

  @override
  String get proFeature3 => '完全な履歴とカレンダー';

  @override
  String get proFeature4 => '習慣ごとのカスタム通知';

  @override
  String get proFeature5 => '将来のアップデートとテーマ';

  @override
  String get yearly => '年間';

  @override
  String get yearlySubtitle => '月額わずか1,66€';

  @override
  String get monthly => '月間';

  @override
  String get monthlySubtitle => 'いつでも解約可能';

  @override
  String get lifetimeOffer => '永久アクセス 39,99€ →';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get proActivated => 'Pro有効化！🎉';

  @override
  String get noPurchasesFound => '購入が見つかりません';

  @override
  String get habitLimitReached => '無料の上限に達しました';

  @override
  String get upgradeToAddMore => 'Proにアップグレードして無制限に';

  @override
  String get upgrade => 'アップグレード';

  @override
  String get proOnly => 'Pro';

  @override
  String get freeLimitedHistory => 'Proで完全な履歴を利用可能';
}
