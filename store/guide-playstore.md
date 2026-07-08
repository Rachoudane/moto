# Google Play Console — Big Update Guide (v1.1.0)

> Moto has been live on Production since launch in February 2026. This is an **update to an existing listing**, not a first-time setup — no need to redo account/app creation, content rating, or IAP setup unless noted below.

## Current state
- Bundle ID: `com.rachoucorp.moto`
- Track: Production (live since Feb 2026)
- Previous shipped version: `1.0.0+2`
- This update: `1.1.0+3`
- Subscriptions: `moto_pro_yearly`, `moto_pro_monthly`, `moto_pro_lifetime`

---

## 1. Build the new release AAB

From the project root:
```powershell
.\build_release.ps1
```
This bumps `pubspec.yaml` (already at `1.1.0+3` for this release — the script will bump the **next** release from there) and runs `flutter build appbundle --release`.

Output: `build\app\outputs\bundle\release\app-release.aab`

For **this specific update**, the version was already hand-bumped to `1.1.0+3` (minor bump, since this is a big feature update, not a routine patch). If you haven't built yet, just run:
```powershell
flutter build appbundle --release
```

---

## 2. Update Screenshots (all 3 languages)

1. Open [Play Console](https://play.google.com/console) → select **Moto**
2. Left menu → **Grow** → **Store presence** → **Main store listing** (English / default)
3. Scroll to **Phone screenshots** → delete the old 5-set → upload all 6 from `screenshots/final/playstore/en/`
4. Scroll to **Feature graphic** → replace with `screenshots/final/playstore/feature-graphic/feature-graphic-en.png`
5. **Save**

### French listing
1. **Grow** → **Store presence** → **Manage translations** (French should already exist from launch — if not, **Add language** → French (fr-FR))
2. Screenshots: upload all 6 from `screenshots/final/playstore/fr/`
3. Feature graphic: `screenshots/final/playstore/feature-graphic/feature-graphic-fr.png`
4. **Save**

### Japanese listing
1. Same path, language **Japanese (ja-JP)**
2. Screenshots: upload all 6 from `screenshots/final/playstore/ja/`
3. Feature graphic: `screenshots/final/playstore/feature-graphic/feature-graphic-ja.png`
4. **Save**

Screenshot order (same for all 3 languages):
1. `01-grow-squares.jpg` — core square-growth mechanic
2. `02-keep-trophies.jpg` — permanent trophies
3. `03-unlock-badges.jpg` — badge system (new)
4. `04-choose-challenge.jpg` — penalty modes
5. `05-build-break.jpg` — build/quit habits
6. `06-meet-motosan.jpg` — Moto-san mascot (new)

---

## 3. Update Store Listing Text (all 3 languages)

1. **Main store listing** (EN) → replace:
   - **App name**, **Short description**, **Full description** → see `metadata/playstore-en.md`
2. **Save**
3. Repeat for **French** using `metadata/playstore-fr.md`
4. Repeat for **Japanese** using `metadata/playstore-ja.md`

---

## 4. Verify Subscriptions Are Still Active

1. Left menu → **Monetize** → **Products** → **Subscriptions**
2. Confirm all 3 are **Active**: `moto_pro_yearly`, `moto_pro_monthly`, `moto_pro_lifetime`
3. No changes needed here unless pricing changed — this update is feature/content only.

---

## 5. Roll Out the New Release

1. Left menu → **Release** → **Production** → **Create new release**
2. Upload `build\app\outputs\bundle\release\app-release.aab`
3. **Release name**: `1.1.0 (3)`
4. **Release notes** — paste per language from `metadata/whatsnew.md`:
   - `en-US`, `fr-FR`, `ja-JP`
5. **Review release** → **Start rollout to Production**
6. Rollout percentage: start at **20%** given this is a large update with real behavior changes (streak recalculation, history editing, badge logic) — watch crash-free rate and reviews for 24–48h before going to 100%.

> Google Play review typically takes a few hours to 1–2 days.

---

## 6. Post-rollout checklist
- [ ] Screenshots updated (EN + FR + JA), including feature graphic
- [ ] Store listing text updated (EN + FR + JA)
- [ ] Release notes added (EN + FR + JA)
- [ ] Subscriptions verified active
- [ ] AAB built from `1.1.0+3`, uploaded
- [ ] Staged rollout started (20%)
- [ ] Monitor **Quality** → **Android vitals** for crash rate over the next 48h before widening rollout
- [ ] Once stable at 100%, tag the release in git: `git tag v1.1.0 && git push origin v1.1.0`

---

## Key URLs
- Play Console: https://play.google.com/console
- Live listing: https://play.google.com/store/apps/details?id=com.rachoucorp.moto
