# Release Notes — v1.1.0 (versionCode 3)

Play Store "What's new" field, max 500 chars per language.

## English (329 chars)
```
Moto's biggest update yet: 20+ badges to unlock, meet Moto-san (your new habit companion), daily motivational quotes, richer history editing with badge celebrations, and easier progress sharing. Plus dozens of stability and streak-accuracy fixes under the hood. Update now and keep building your foundation, one square at a time.
```

## Français (405 caractères)
```
La plus grosse mise à jour de Moto : plus de 20 badges à débloquer, Moto-san (votre nouveau compagnon d'habitudes), une citation motivante chaque jour, une édition d'historique enrichie avec célébration des badges, et un partage de progression facilité. Ajoutez à cela de nombreuses corrections de stabilité et de précision des séries. Mettez à jour et continuez à construire vos habitudes, case par case.
```

## 日本語 (133文字)
```
Motoの過去最大のアップデート：20種類以上のバッジを解除、新しい相棒モトさんが登場、毎日届くやる気の名言、バッジ演出つきの履歴編集強化、進捗シェアがより簡単に。さらに安定性と連続記録の精度に関する多数の修正も。アップデートして、習慣を一マスずつ育て続けましょう。
```

---

## What actually shipped since launch (Feb 12, v1.0.0+2 → Jul 8, v1.1.0+3)
Source: full feature/fix list for context — condense further for future smaller updates, don't reuse this whole list verbatim next time.

**New features**
- Badges & milestones system (20+ badges: streaks, totals, habit count, time-of-day, secret badges)
- Moto-san mascot, with onboarding rebuilt around him
- Daily motivational quotes
- Habit history editing (retroactively edit past days) with stacked badge-unlock celebrations
- Habit frequency options (not just daily)
- Richer sharing (progress, badges, squares, app referral) with multiple message variants per language
- Tiered badge medallions with category tint and progress rings

**Stability / correctness fixes**
- Streak recalculation accuracy overhaul
- Fixed badge-unlock race condition on overlapping checkAndUnlock calls
- Fixed streak/square not updating for history edits made before habit creation
- Stopped silently downgrading Pro users on transient verification gaps
- Fixed crash validating a habit with reminder on but no time set
- Habits now refresh correctly on midnight rollover and app resume
- Rest days are now skipped when scheduling habit reminders
- Calendar accessibility polish, error handling hardening across the app
