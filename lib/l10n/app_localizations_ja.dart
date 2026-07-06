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
  String get frequency => '頻度';

  @override
  String get everyDay => '毎日';

  @override
  String get specificDays => '特定の曜日';

  @override
  String get restDay => '休息日';

  @override
  String get penaltyMode => 'ペナルティモード';

  @override
  String get zen => '禅';

  @override
  String get standard => '普通';

  @override
  String get hardcore => '本気';

  @override
  String get zenDescription => '穏やかな進歩 — 1日休んでも1ポイントだけ減少。プレッシャーなく習慣を作りたい方に。';

  @override
  String get standardDescription =>
      'バランスの取れた挑戦 — 1日休むと前のレベルに戻る。厳しすぎずモチベーションを維持。';

  @override
  String get hardcoreDescription => '容赦なし — 1日休むとゼロからやり直し。プレッシャーの中で力を発揮する方向け。';

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
  String get reorderHabit => 'ドラッグして並べ替え';

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
  String get onboardingTitle5 => 'Proでさらに先へ';

  @override
  String get onboardingDesc5 =>
      '無制限の習慣、すべてのモード、リマインダーなどを解放。または無料で始めて、いつでもアップグレード可能。';

  @override
  String get continueFree => '無料で続ける';

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
  String get yearlySubtitle => '最もお得';

  @override
  String get perMonth => '/月';

  @override
  String savePercent(int percent) {
    return '$percent%オフ';
  }

  @override
  String get monthly => '月間';

  @override
  String get monthlySubtitle => 'いつでも解約可能';

  @override
  String get lifetimeOffer => '永久アクセス →';

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
  String get penaltyModeProTitle => 'Proモード';

  @override
  String get penaltyModeProDescription => '禅モードと本気モードはProで利用可能。さまざまな挑戦レベルを試そう！';

  @override
  String get reminderProTitle => 'Pro機能';

  @override
  String get reminderProDescription => '習慣ごとのカスタムリマインダーはProで利用可能。毎日を逃さない！';

  @override
  String get themeProTitle => 'Proテーマ';

  @override
  String get themeProDescription => 'ライトモードと将来のテーマはProで利用可能。体験をカスタマイズしよう！';

  @override
  String get upgrade => 'アップグレード';

  @override
  String get proOnly => 'Pro';

  @override
  String get freeLimitedHistory => 'Proで完全な履歴を利用可能';

  @override
  String get productNotAvailable =>
      '商品が利用できません。Play Storeからインストールするか、リリースモードで実行してください。';

  @override
  String get badgesTitle => 'バッジ';

  @override
  String badgesUnlockedCount(int count, int total) {
    return '$total個中$count個解除済み';
  }

  @override
  String get badgeUnlockedTitle => 'バッジ解除';

  @override
  String badgeUnlockedOn(String date) {
    return '$dateに解除';
  }

  @override
  String get badgeSecretLockedName => '？？？';

  @override
  String get badgeSecretLockedHint => '続けよう — これは達成した時に明かされる。';

  @override
  String get badgeStreak7Name => '週間の戦士';

  @override
  String get badgeStreak7Desc => '習慣で7日間の連続記録を達成した。';

  @override
  String get badgeStreak30Name => '勢いの構築者';

  @override
  String get badgeStreak30Desc => '30日間の連続記録を達成。本物の習慣が形成されている。';

  @override
  String get badgeStreak100Name => '百人隊長';

  @override
  String get badgeStreak100Desc => '100日連続。これが今のあなただ。';

  @override
  String get badgeStreak365Name => '一巡り';

  @override
  String get badgeStreak365Desc => '一年間、一日ずつ。';

  @override
  String get badgeSquare1Name => '最初の石';

  @override
  String get badgeSquare1Desc => '初めての1×1の正方形を完成させた。';

  @override
  String get badgeSquare2Name => '土台完成';

  @override
  String get badgeSquare2Desc => '2×2の正方形を完成させた。';

  @override
  String get badgeSquare3Name => '積み上げ中';

  @override
  String get badgeSquare3Desc => '3×3の正方形を完成させた。';

  @override
  String get badgeSquare5Name => '建築家';

  @override
  String get badgeSquare5Desc => '5×5の正方形を完成させた。';

  @override
  String get badgeSquare8Name => '棟梁';

  @override
  String get badgeSquare8Desc => '8×8の正方形を完成させた。';

  @override
  String get badgeCells10Name => 'はじめの一歩';

  @override
  String get badgeCells10Desc => '全習慣合わせて合計10日達成。';

  @override
  String get badgeCells50Name => '着実な歩み';

  @override
  String get badgeCells50Desc => '合計50日達成。';

  @override
  String get badgeCells100Name => '百日クラブ';

  @override
  String get badgeCells100Desc => '合計100日達成。';

  @override
  String get badgeCells500Name => '鋼の意志';

  @override
  String get badgeCells500Desc => '合計500日達成。';

  @override
  String get badgeCells1000Name => '伝説';

  @override
  String get badgeCells1000Desc => '合計1000日達成。並外れている。';

  @override
  String get badgeHabits3Name => 'マルチタスカー';

  @override
  String get badgeHabits3Desc => '同時に3つの習慣を管理中。';

  @override
  String get badgeHabits5Name => 'ジャグラー';

  @override
  String get badgeHabits5Desc => '同時に5つの習慣を管理中。';

  @override
  String get badgeHabits10Name => '習慣コレクター';

  @override
  String get badgeHabits10Desc => '同時に10の習慣を管理中。';

  @override
  String get badgeEarlyBirdName => '早起き鳥';

  @override
  String get badgeEarlyBirdDesc => '午前7時前に習慣を達成した。';

  @override
  String get badgeNightOwlName => '夜更かしフクロウ';

  @override
  String get badgeNightOwlDesc => '午後10時以降に習慣を達成した。';

  @override
  String get badgeWeekendWarriorName => '週末の戦士';

  @override
  String get badgeWeekendWarriorDesc => '土曜日と日曜日の両方を継続した。';

  @override
  String get badgeComebackName => 'カムバック';

  @override
  String get badgeComebackDesc => '3日以上連続で休んだ後、達成に戻ってきた。';

  @override
  String get badgePerfectWeekName => '完璧な一週間';

  @override
  String get badgePerfectWeekDesc => '7日連続、失敗ゼロ。';

  @override
  String get badgePerfectMonthName => '完璧な一ヶ月';

  @override
  String get badgePerfectMonthDesc => '30日連続、失敗ゼロ。';

  @override
  String get badgeHardcoreSurvivorName => '本気モードの生存者';

  @override
  String get badgeHardcoreSurvivorDesc => '本気モードで30日間リセットなしに生き延びた。';

  @override
  String get badgeZenMasterName => '禅マスター';

  @override
  String get badgeZenMasterDesc => '禅モードで100日達成。';

  @override
  String get badgeSecretPerfectionistName => '完璧主義者';

  @override
  String get badgeSecretPerfectionistDesc => '20回以上の記録で一度も欠かしたことがない。';

  @override
  String get badgeSecretMultitaskerName => '五輪の集中';

  @override
  String get badgeSecretMultitaskerDesc => '同時に5つの習慣で連続記録を維持した。';

  @override
  String get shareMyProgress => '進捗をシェア';

  @override
  String get shareFindOnAppStore => 'App Storeで「Moto」を検索してください。';

  @override
  String get shareAppMsg1 => 'Motoで良い習慣を築いています。ひとマスずつ。🧱 一緒に築こう。';

  @override
  String get shareAppMsg2 => '習慣が本当に続くアプリを見つけた：Moto。継続を目に見える成長に変えてくれる。🌱';

  @override
  String get shareAppMsg3 => 'Motoは毎日の習慣を、実際に成長が見えるものに変えてくれた。試してみて。元';

  @override
  String get shareAppMsg4 => '連続記録に怒られることもなく、ただ一緒に成長する正方形があるだけ。Motoは試す価値あり。🧩';

  @override
  String get shareAppMsg5 => 'Motoで、一日ずつ達成しながら自分の基盤を築いています。一緒にどう？';

  @override
  String get shareAppMsg6 => 'この習慣トラッカーは、継続を本気で勝ちたいゲームに変えてくれた。Moto。🏆';

  @override
  String get shareAppMsg7 => '毎日の小さな行動が、成長する正方形として見える。それがMoto。試してみて。';

  @override
  String shareProgressMsg1(String habitName, int streak) {
    return '「$habitName」で$streakマス達成中。Motoで一日ずつ基盤を築いています。🧱';
  }

  @override
  String shareProgressMsg2(String habitName, int streak) {
    return '「$habitName」が少しずつ形になってきた — Motoで現在$streakマス。🌱';
  }

  @override
  String shareProgressMsg3(String habitName, int streak) {
    return '「$habitName」で$streak日達成。Motoが私を正直にさせてくれる。元';
  }

  @override
  String shareProgressMsg4(String habitName, int streak) {
    return '「$habitName」がマスごとに成長していくのを見ている — Motoで$streakマス。';
  }

  @override
  String shareProgressMsg5(String habitName, int streak) {
    return '「$habitName」の記録がMotoで$streakマスに到達。小さな一歩が本当の進歩に。';
  }

  @override
  String shareBadgeMsg1(String badgeName) {
    return 'Motoで「$badgeName」バッジを解除した！🏆';
  }

  @override
  String shareBadgeMsg2(String badgeName) {
    return '新しいトロフィー解除：Motoの「$badgeName」。気分がいい。元';
  }

  @override
  String shareBadgeMsg3(String badgeName) {
    return '継続が実を結んだ — Motoで「$badgeName」バッジを獲得！';
  }

  @override
  String shareBadgeMsg4(String badgeName) {
    return '「$badgeName」— Motoで解除。小さな積み重ねが実を結ぶ証拠がまた一つ。';
  }

  @override
  String shareBadgeMsg5(String badgeName) {
    return 'Motoから「$badgeName」バッジをもらった。この調子で。🌱';
  }

  @override
  String shareSquareMsg1(String habitName, int level) {
    return 'Motoで「$habitName」の$level×$levelの正方形を完成させた！🧱';
  }

  @override
  String shareSquareMsg2(String habitName, int level) {
    return '「$habitName」がレベルアップ — Motoで$level×$levelの正方形が完成。';
  }

  @override
  String shareSquareMsg3(String habitName, int level) {
    return 'またトロフィー獲得：「$habitName」で$level×$level。Motoが証明してくれる。元';
  }

  @override
  String shareSquareMsg4(String habitName, int level) {
    return '正方形完成！「$habitName」で$level×$level — 一日ずつ積み上げた結果。';
  }

  @override
  String shareSquareMsg5(String habitName, int level) {
    return '「$habitName」がMotoで$level×$levelの正方形に到達。継続が目に見える形に。';
  }

  @override
  String squareCompletedCelebration(int count) {
    return '🎉 正方形完成！$count×$countを完成させた。';
  }

  @override
  String streakMilestoneCelebration(int streak) {
    return '🔥 $streak日連続達成！この勢いを続けよう。';
  }

  @override
  String get proDowngradeTitle => 'Proサブスクリプションが終了しました';

  @override
  String get proDowngradeDescription =>
      '心配いりません — すべての習慣と履歴は安全です。現在は無料プランに戻っています。いつでも再登録してすべてを再び解放できます。';

  @override
  String get proPromoCardTitle => 'Proでさらに先へ';

  @override
  String get proPromoCardSubtitle => '無制限の習慣、完全な履歴など。';

  @override
  String get proSocialProof => '何千人もの人がMoto Proでより良い習慣を築いています';

  @override
  String get editHistoryProTitle => '全履歴を編集';

  @override
  String get editHistoryProDescription =>
      '7日より前の日付の編集はProで利用可能です。無料アカウントは直近1週間を修正できます。';

  @override
  String get clearDay => 'この日をクリア';

  @override
  String get dailyQuoteNotification => '今日の一言';

  @override
  String get dailyQuoteNotificationDescription =>
      '毎朝8時にモチベーションの一言をお届け。全ユーザー無料。';

  @override
  String get quietHours => '静かな時間帯';

  @override
  String get quietHoursDescription => 'この時間帯はリマインダーが送信されません';

  @override
  String get quietHoursStart => '開始';

  @override
  String get quietHoursEnd => '終了';

  @override
  String get sendTestNotification => 'テスト通知を送信';

  @override
  String get sendTestNotificationDescription => 'リマインダーが正しく機能しているか確認';

  @override
  String get testNotificationBody =>
      'これはMotoからのテスト通知です。これが見えていれば、リマインダーは正常に機能しています！🔔';

  @override
  String get testNotificationSent => 'テスト通知を送信しました';

  @override
  String reminderGentle1(String habit) {
    return 'プレッシャーはいらない — 今日、準備ができたときに$habitをしよう。';
  }

  @override
  String reminderGentle2(String habit) {
    return 'そっと一言：$habitがあなたを待っています。';
  }

  @override
  String reminderGentle3(String habit) {
    return '今日、少し時間ができたときに、$habitに取り組んでみて。';
  }

  @override
  String reminderPlayful1(String habit) {
    return 'ねえ。$habitから連絡があったよ。会いたいって。';
  }

  @override
  String reminderPlayful2(String habit) {
    return 'あなたの正方形が成長を待っている。今日は$habitで育ててあげよう。';
  }

  @override
  String reminderPlayful3(String habit) {
    return 'どんでん返し：今日は$habitにぴったりの日だ。';
  }

  @override
  String reminderWeekendVibe(String habit) {
    return '週末でも、$habitは休まない。';
  }

  @override
  String reminderStreakMilestone(String habit, int streak) {
    return '$habitで$streak日達成。ここで止まらないで。';
  }
}
