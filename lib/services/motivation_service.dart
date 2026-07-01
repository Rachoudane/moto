class MotivationQuote {
  final String en;
  final String fr;
  final String ja;

  const MotivationQuote({required this.en, required this.fr, required this.ja});
}

/// Daily motivational content shown on the home screen and folded into
/// morning notifications. Quotes are static (no network/storage needed) and
/// resolved deterministically per day so the same quote holds all day.
class MotivationService {
  static const List<MotivationQuote> _quotes = [
    // --- Japanese philosophy ---
    MotivationQuote(
      en: "Kaizen: improvement doesn't need to be big to be real. One percent, every day, is how mountains get built.",
      fr: "Kaizen : le progrès n'a pas besoin d'être spectaculaire pour être réel. Un pour cent par jour, c'est comme ça qu'on déplace des montagnes.",
      ja: "改善（かいぜん）— 小さな一歩でも本物の前進。毎日の一パーセントが、いつか山を築く。",
    ),
    MotivationQuote(
      en: "Ikigai isn't found sitting still. It's uncovered one deliberate action at a time.",
      fr: "L'ikigai ne se trouve pas en restant immobile. Il se révèle une action volontaire à la fois.",
      ja: "生き甲斐（いきがい）はじっとして見つかるものではない。ひとつひとつの行動の中で少しずつ見えてくる。",
    ),
    MotivationQuote(
      en: "Wabi-sabi teaches that beauty lives in the imperfect and unfinished. Your streak doesn't have to be flawless to be worth keeping.",
      fr: "Le wabi-sabi enseigne que la beauté réside dans l'imparfait et l'inachevé. Ta série n'a pas besoin d'être parfaite pour valoir la peine.",
      ja: "侘び寂び（わびさび）は不完全さの中に美を見出す。完璧でなくても、続けてきた記録には価値がある。",
    ),
    MotivationQuote(
      en: "Ganbatte — do your best, right up to the edge of what you have today. That's all anyone can ask.",
      fr: "Ganbatte — donne le meilleur de toi-même, jusqu'à la limite de ce que tu as aujourd'hui. C'est tout ce qu'on peut te demander.",
      ja: "頑張って（がんばって）— 今日出せる力を出し切る。それ以上を求める必要はない。",
    ),
    MotivationQuote(
      en: "Shoshin, the beginner's mind: approach today's habit as if it were your first day. Curiosity beats routine.",
      fr: "Shoshin, l'esprit du débutant : aborde l'habitude d'aujourd'hui comme si c'était ton premier jour. La curiosité bat la routine.",
      ja: "初心（しょしん）— 今日の習慣を初日のように取り組む。好奇心はマンネリに勝る。",
    ),
    MotivationQuote(
      en: "Mono no aware: even the ordinary Tuesday you almost skipped is a moment that won't come again. Don't waste it.",
      fr: "Mono no aware : même ce mardi ordinaire que tu as failli sauter est un instant qui ne reviendra jamais. Ne le gâche pas.",
      ja: "物の哀れ（もののあわれ）— 見過ごしそうな平凡な火曜日も、二度と来ない瞬間。無駄にしないで。",
    ),
    MotivationQuote(
      en: "Ichi-go ichi-e: this exact moment, this exact chance to show up, happens once. Take it.",
      fr: "Ichi-go ichi-e : ce moment précis, cette occasion précise de te montrer présent, n'arrive qu'une fois. Saisis-la.",
      ja: "一期一会（いちごいちえ）— 今日というこの機会は一度きり。逃さずに。",
    ),
    MotivationQuote(
      en: "Gaman is quiet endurance — not gritting your teeth in misery, but calmly carrying on when it would be easier to stop.",
      fr: "Le gaman, c'est l'endurance tranquille — pas serrer les dents dans la souffrance, mais continuer calmement quand il serait plus facile d'arrêter.",
      ja: "我慢（がまん）は静かな忍耐。苦しみに耐えるのではなく、やめる方が楽な時にも淡々と続けること。",
    ),
    MotivationQuote(
      en: "Nintai, patience without resentment: the square you're building today won't finish today, and that's fine.",
      fr: "Nintai, la patience sans rancœur : le carré que tu construis aujourd'hui ne se terminera pas aujourd'hui, et c'est très bien ainsi.",
      ja: "忍耐（にんたい）— 恨まずに待つこと。今日築く四角形は今日完成しなくていい。",
    ),
    MotivationQuote(
      en: "Kodawari is an uncompromising care for the small details — the kind of care that turns habits into craft.",
      fr: "Le kodawari, c'est ce soin sans compromis pour les petits détails — celui qui transforme des habitudes en art.",
      ja: "こだわりは細部への妥協なき配慮。それが習慣を職人技へと変える。",
    ),
    MotivationQuote(
      en: "Oubaitori: plum, cherry, peach, and apricot blossoms all bloom in their own time. Don't compare your streak to anyone else's.",
      fr: "Oubaitori : prunier, cerisier, pêcher et abricotier fleurissent chacun à leur propre rythme. Ne compare pas ta série à celle des autres.",
      ja: "桜梅桃李（おうばいとうり）— 梅も桜も桃も李も、それぞれの時に咲く。他人の記録と比べなくていい。",
    ),
    MotivationQuote(
      en: "Fudoshin, the immovable mind: let today's mood rise and fall, but let your action stay steady underneath it.",
      fr: "Fudoshin, l'esprit inébranlable : laisse l'humeur du jour monter et descendre, mais garde ton action stable en dessous.",
      ja: "不動心（ふどうしん）— 今日の気分は揺れても、その下にある行動は揺るがせない。",
    ),

    // --- Building / foundation metaphors ---
    MotivationQuote(
      en: "元 (moto) means origin, root, foundation. Every square you finish becomes bedrock for the next one.",
      fr: "元 (moto) signifie origine, racine, fondation. Chaque carré terminé devient le socle du suivant.",
      ja: "元（もと）は起源、根、土台を意味する。完成した四角形はすべて次の礎になる。",
    ),
    MotivationQuote(
      en: "No one admires a building for its first brick alone — they admire what all the bricks became together.",
      fr: "Personne n'admire un bâtiment pour sa première brique seule — on admire ce que toutes les briques sont devenues ensemble.",
      ja: "誰も最初の一枚のレンガだけを見て建物を賞賛しない。すべてのレンガが積み重なった結果を見るのだ。",
    ),
    MotivationQuote(
      en: "A foundation poured carelessly cracks under weight later. Lay today's stone with the same care you'll want the whole structure to have.",
      fr: "Une fondation coulée à la hâte se fissure sous le poids plus tard. Pose la pierre d'aujourd'hui avec le soin que tu voudras retrouver dans toute la structure.",
      ja: "雑に打たれた土台は、後で重みに耐えられず割れる。今日の一石を、全体に望む丁寧さで積もう。",
    ),
    MotivationQuote(
      en: "You're not chasing a streak number. You're pouring concrete, one day at a time, for something that will outlast the excuse to stop.",
      fr: "Tu ne cours pas après un chiffre. Tu coules du béton, un jour à la fois, pour bâtir quelque chose qui survivra à la moindre excuse d'arrêter.",
      ja: "あなたが追っているのは数字ではない。やめる言い訳より長く残るものを、一日ずつコンクリートのように固めているのだ。",
    ),
    MotivationQuote(
      en: "Trophies don't get taken away when you stumble. What you've already built stays built.",
      fr: "Les trophées ne disparaissent pas quand tu trébuches. Ce que tu as déjà construit reste construit.",
      ja: "つまずいても、獲得したトロフィーは消えない。すでに築いたものは築かれたまま。",
    ),
    MotivationQuote(
      en: "A 1×1 looks small next to a 5×5. It never looked small the day you built it.",
      fr: "Un 1×1 paraît minuscule à côté d'un 5×5. Il ne t'a jamais paru minuscule le jour où tu l'as bâti.",
      ja: "1×1は5×5の隣では小さく見える。だが、それを築いたその日には、決して小さくは感じなかったはずだ。",
    ),
    MotivationQuote(
      en: "Every square you've ever completed is still standing somewhere behind you. That's not nothing.",
      fr: "Chaque carré que tu as jamais complété est encore debout, quelque part derrière toi. Ce n'est pas rien.",
      ja: "これまで完成させたすべての四角形は、今も背後にしっかりと立っている。それは決して無ではない。",
    ),
    MotivationQuote(
      en: "Foundations are invisible once the building stands. So is most of your discipline. Both are still load-bearing.",
      fr: "Les fondations deviennent invisibles une fois le bâtiment debout. Il en va de même pour la plupart de ta discipline. Les deux portent toujours la charge.",
      ja: "建物が立つと土台は見えなくなる。あなたの努力の多くも同じだ。それでも、どちらも支え続けている。",
    ),
    MotivationQuote(
      en: "You don't need scaffolding forever. You need it today. Tomorrow you'll need it again. That's the whole job.",
      fr: "Tu n'as pas besoin d'échafaudage pour toujours. Tu en as besoin aujourd'hui. Demain, tu en auras besoin à nouveau. C'est tout le travail.",
      ja: "足場は永遠には必要ない。必要なのは今日だけ。明日また必要になる。それが仕事のすべてだ。",
    ),
    MotivationQuote(
      en: "A single cell added today is a small thing. A thousand cells added over a year is a monument.",
      fr: "Une seule case ajoutée aujourd'hui, c'est peu de chose. Mille cases ajoutées en un an, c'est un monument.",
      ja: "今日加える一マスは小さなこと。だが一年で積み上がる千のマスは、記念碑になる。",
    ),
    MotivationQuote(
      en: "Build like you're not in a hurry, and show up like you can't afford to wait.",
      fr: "Construis comme si tu n'étais pas pressé, et présente-toi comme si tu ne pouvais pas te permettre d'attendre.",
      ja: "急がずに築き、待てないかのように今日を始めよう。",
    ),

    // --- Consistency / small steps ---
    MotivationQuote(
      en: "You don't need motivation today. You need five minutes and a decision.",
      fr: "Tu n'as pas besoin de motivation aujourd'hui. Tu as besoin de cinq minutes et d'une décision.",
      ja: "今日必要なのはやる気ではない。5分と、やると決めることだけだ。",
    ),
    MotivationQuote(
      en: "Small and consistent beats big and occasional, every single time.",
      fr: "Petit et régulier bat grand et occasionnel, à chaque fois.",
      ja: "小さくても続けることは、大きくても時々しかやらないことに、必ず勝る。",
    ),
    MotivationQuote(
      en: "The habit doesn't care how you feel about it. Show up anyway — feelings tend to follow action, not the other way around.",
      fr: "L'habitude se moque de ce que tu ressens à son sujet. Présente-toi quand même — les sentiments suivent souvent l'action, pas l'inverse.",
      ja: "習慣はあなたの気分など気にしない。とにかくやろう。感情は行動の後についてくるものだ。",
    ),
    MotivationQuote(
      en: "Discipline is just a promise you keep to yourself when no one's watching to see if you did.",
      fr: "La discipline, c'est juste une promesse que tu tiens envers toi-même, même quand personne ne regarde.",
      ja: "規律とは、誰も見ていなくても自分自身に守る約束のことだ。",
    ),
    MotivationQuote(
      en: "Consistency isn't glamorous. It's also the only thing that's ever actually worked.",
      fr: "La régularité n'a rien de glamour. C'est aussi la seule chose qui ait jamais vraiment fonctionné.",
      ja: "継続は華やかではない。だが、本当に効果があったのは結局それだけだ。",
    ),
    MotivationQuote(
      en: "Momentum is cheaper to keep than to rebuild. Protect today's rep, even a small one.",
      fr: "L'élan coûte moins cher à maintenir qu'à reconstruire. Protège la répétition d'aujourd'hui, même petite.",
      ja: "勢いは、失ってから取り戻すより、保つ方がずっと安く済む。今日の一回を、たとえ小さくても大切に。",
    ),
    MotivationQuote(
      en: "You're not behind. You're exactly as far along as someone who kept showing up would be.",
      fr: "Tu n'es pas en retard. Tu es exactement là où serait quelqu'un qui a continué à se montrer présent.",
      ja: "遅れてなどいない。あなたは、続けてきた人がいるべき場所に、ちょうどいる。",
    ),
    MotivationQuote(
      en: "The version of you a year from now is being built entirely out of days like today.",
      fr: "La version de toi dans un an se construit entièrement à partir de journées comme celle-ci.",
      ja: "一年後のあなたは、今日のような日々の積み重ねから作られている。",
    ),
    MotivationQuote(
      en: "Whatever today's habit is, it's smaller than the excuse not to do it. Do the small thing.",
      fr: "Quelle que soit l'habitude d'aujourd'hui, elle est plus petite que l'excuse pour ne pas la faire. Fais la petite chose.",
      ja: "今日の習慣がどんなものであれ、やらない言い訳より小さいはずだ。だからその小さなことをやろう。",
    ),
    MotivationQuote(
      en: "You won't remember most ordinary days. You'll remember what they added up to.",
      fr: "Tu ne te souviendras pas de la plupart des jours ordinaires. Tu te souviendras de ce qu'ils ont fini par créer.",
      ja: "平凡な一日の多くは覚えていないだろう。だが、それらが積み重なった結果は覚えているはずだ。",
    ),

    // --- Self-improvement ---
    MotivationQuote(
      en: "Growth rarely feels dramatic while it's happening. It only looks dramatic in hindsight.",
      fr: "La croissance semble rarement spectaculaire pendant qu'elle se produit. Elle ne paraît spectaculaire qu'a posteriori.",
      ja: "成長はその最中にはドラマチックに感じられない。振り返って初めてそう見えるのだ。",
    ),
    MotivationQuote(
      en: "You're allowed to be a work in progress and still be proud of the progress.",
      fr: "Tu as le droit d'être un travail en cours et d'être quand même fier de ce chemin parcouru.",
      ja: "まだ発展途上であっても、その進歩を誇りに思っていい。",
    ),
    MotivationQuote(
      en: "Improvement compounds quietly. Trust the math even on days you can't see the result.",
      fr: "L'amélioration se compose silencieusement. Fais confiance aux mathématiques, même les jours où tu n'en vois pas le résultat.",
      ja: "成長は静かに複利で積み重なる。結果が見えない日でも、その数学を信じよう。",
    ),
    MotivationQuote(
      en: "The person who never misses isn't stronger than you. They just decided misses don't get to end the streak of trying.",
      fr: "La personne qui ne rate jamais n'est pas plus forte que toi. Elle a juste décidé que les échecs ne mettaient pas fin à la série d'essais.",
      ja: "一度も欠かさない人が、あなたより強いわけではない。ただ、失敗しても挑戦をやめないと決めただけだ。",
    ),
    MotivationQuote(
      en: "Becoming someone new is mostly just doing the boring thing your future self will thank you for.",
      fr: "Devenir quelqu'un de nouveau, c'est surtout faire cette chose ennuyeuse dont ton futur toi te remerciera.",
      ja: "新しい自分になるとは、たいてい、未来の自分が感謝するであろう地味なことをやり続けることだ。",
    ),
    MotivationQuote(
      en: "Your standards, not your motivation, are what get you through the days motivation forgets to show up.",
      fr: "Ce sont tes exigences, pas ta motivation, qui te font traverser les jours où la motivation oublie de se présenter.",
      ja: "やる気が来ない日に支えてくれるのは、やる気ではなく、自分に課した基準だ。",
    ),
    MotivationQuote(
      en: "You're not trying to be perfect. You're trying to be someone who keeps trying.",
      fr: "Tu n'essaies pas d'être parfait. Tu essaies d'être quelqu'un qui continue d'essayer.",
      ja: "完璧を目指しているのではない。挑戦し続ける人になろうとしているのだ。",
    ),
    MotivationQuote(
      en: "Self-respect is built the same way everything else is: one kept promise at a time.",
      fr: "L'estime de soi se construit de la même façon que tout le reste : une promesse tenue à la fois.",
      ja: "自尊心も他のすべてと同じように築かれる。守った約束をひとつずつ積み重ねて。",
    ),

    // --- Resilience / comebacks ---
    MotivationQuote(
      en: "A missed day doesn't erase the ones before it. It's just one day. Don't let it become two.",
      fr: "Un jour manqué n'efface pas ceux d'avant. Ce n'est qu'un jour. Ne le laisse pas en devenir deux.",
      ja: "一日欠かしても、それ以前の日々は消えない。ただの一日だ。それを二日にしないように。",
    ),
    MotivationQuote(
      en: "Falling off isn't the failure. Staying off is.",
      fr: "Tomber n'est pas l'échec. Rester par terre, ça l'est.",
      ja: "つまずくことが失敗なのではない。そのまま起き上がらないことが失敗なのだ。",
    ),
    MotivationQuote(
      en: "Coming back after a gap takes more courage than never having left. Welcome back.",
      fr: "Revenir après une pause demande plus de courage que de ne jamais être parti. Bon retour.",
      ja: "空白の後に戻ってくることは、一度も離れなかったことよりも勇気がいる。おかえりなさい。",
    ),
    MotivationQuote(
      en: "Your history has some skipped days in it. So does everyone's who ever finished anything.",
      fr: "Ton historique contient quelques jours manqués. C'est le cas de tous ceux qui ont un jour terminé quelque chose.",
      ja: "あなたの記録にも欠けた日がある。何かを成し遂げた人は皆、そうだったのだ。",
    ),
    MotivationQuote(
      en: "The penalty resets a number, not the fact that you already proved you could do this.",
      fr: "La pénalité réinitialise un chiffre, pas le fait que tu as déjà prouvé que tu en étais capable.",
      ja: "ペナルティは数字をリセットするだけ。あなたがすでにそれをやり遂げられると証明した事実は消えない。",
    ),
    MotivationQuote(
      en: "You've recovered from worse than today. Today is just the next rep.",
      fr: "Tu t'es relevé de pires journées que celle-ci. Aujourd'hui, c'est juste la prochaine répétition.",
      ja: "あなたは今日より悪い状況からも立ち直ってきた。今日はただ次の一歩に過ぎない。",
    ),
    MotivationQuote(
      en: "Setbacks are data, not verdicts. Adjust and continue.",
      fr: "Les revers sont des données, pas des verdicts. Ajuste et continue.",
      ja: "挫折は判決ではなく、ただのデータだ。調整して、続けよう。",
    ),
    MotivationQuote(
      en: "Whatever broke your streak yesterday doesn't get a vote in what you do today.",
      fr: "Ce qui a brisé ta série hier n'a pas son mot à dire sur ce que tu fais aujourd'hui.",
      ja: "昨日あなたの記録を止めたものに、今日の行動を決める権利はない。",
    ),

    // --- Mindfulness ---
    MotivationQuote(
      en: "You only ever have to do today's version of this. Not this week's. Not this year's. Just today's.",
      fr: "Tu n'as jamais qu'à faire la version d'aujourd'hui de cette habitude. Pas celle de la semaine. Pas celle de l'année. Juste celle d'aujourd'hui.",
      ja: "やるべきなのはいつも「今日の分」だけ。今週分でも今年分でもない。ただ今日の分だけでいい。",
    ),
    MotivationQuote(
      en: "Notice how it actually feels to follow through, not just how you imagined it would feel beforehand.",
      fr: "Remarque comment c'est réellement de tenir parole, pas seulement comment tu imaginais que ce serait avant.",
      ja: "やり遂げた実際の感覚に気づこう。事前に想像していた感覚ではなく。",
    ),
    MotivationQuote(
      en: "Breathe. This is one action, in one moment. It doesn't need to carry the weight of your whole year.",
      fr: "Respire. C'est une seule action, à un seul instant. Elle n'a pas besoin de porter le poids de toute ton année.",
      ja: "深呼吸を。これはある瞬間のひとつの行動。あなたの一年全体を背負う必要はない。",
    ),
    MotivationQuote(
      en: "Presence beats perfection. Show up fully for the two minutes this actually takes.",
      fr: "La présence bat la perfection. Sois pleinement là pour les deux minutes que ça prend vraiment.",
      ja: "存在感は完璧さに勝る。実際にかかる数分間、しっかりとその場にいよう。",
    ),
    MotivationQuote(
      en: "The urge to skip is a passing weather system, not a permanent forecast.",
      fr: "L'envie de sauter est un système météo passager, pas une prévision permanente.",
      ja: "サボりたい気持ちは、通り過ぎる天気であって、永遠の予報ではない。",
    ),
    MotivationQuote(
      en: "Notice the resistance, thank it for showing up, and do the thing anyway.",
      fr: "Remarque la résistance, remercie-la d'être venue, et fais quand même ce qu'il faut faire.",
      ja: "抵抗する気持ちに気づき、それに感謝しつつ、それでもやるべきことをやろう。",
    ),
    MotivationQuote(
      en: "This isn't a test you can fail. It's a practice you keep returning to.",
      fr: "Ce n'est pas un test que tu peux rater. C'est une pratique à laquelle tu reviens sans cesse.",
      ja: "これは失敗できるテストではない。何度でも戻ってくる稽古なのだ。",
    ),
    MotivationQuote(
      en: "Right now, in this exact moment, you have everything you need to take one small action.",
      fr: "En ce moment précis, tu as tout ce qu'il te faut pour poser une petite action.",
      ja: "今このまさに瞬間、小さな一歩を踏み出すために必要なものはすべて揃っている。",
    ),
  ];

  /// Returns today's quote formatted for the given [locale] (en/fr/ja).
  /// Deterministic per calendar day — stable all day, changes at midnight,
  /// no persistence required.
  static String getTodayQuote(String locale) => getQuoteForDate(DateTime.now(), locale);

  /// Same deterministic mapping as [getTodayQuote], but for an arbitrary
  /// [date] — used to pre-compute tomorrow's quote when scheduling the
  /// daily quote notification a day ahead.
  static String getQuoteForDate(DateTime date, String locale) {
    final dayOfYear = DateTime(date.year, date.month, date.day)
        .difference(DateTime(date.year, 1, 1))
        .inDays;
    final quote = _quotes[dayOfYear % _quotes.length];
    switch (locale) {
      case 'fr':
        return quote.fr;
      case 'ja':
        return quote.ja;
      default:
        return quote.en;
    }
  }
}
