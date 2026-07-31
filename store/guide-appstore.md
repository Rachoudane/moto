# App Store Connect — Publication Guide (Moto)

> Adapted from [[project-wingman]]'s App Store setup (`wingman/store/guide-appstore.md`) —
> same Apple Developer account/team (Rachou Corp), same Codemagic + MobAI method,
> different app specifics (3 subscriptions instead of 1 non-consumable, EN+FR+JA
> instead of EN+FR, no ads/AdMob at all).
>
> Status: technical repo-side prep done in this session (bundle ID, encryption
> flag, 6.9" screenshots, Codemagic/GitHub Actions/MobAI scaffolding, privacy
> policy page). Apple Developer account (Rachou Corp) is already active — a
> first Wingman submission was made and rejected, currently in dialogue with
> Apple to resubmit it; same account/team will be used for Moto. Nothing has
> been done yet on Apple's side specifically for Moto (no App Store Connect
> app record, no certs/profiles, no Codemagic project) — this guide is the
> walkthrough for that.

---

## Privacy Policy — now live

`PrivacyMoto.jsx` was added to `react-portfolio` (mirrors `PrivacyWingman.jsx`'s
structure, content adapted to Moto's actual data footprint: no ads, no
analytics, no accounts, no server — just local storage + StoreKit/Play
Billing IAP). Route: `/privacy-moto`. **Deploy react-portfolio before
submitting** so `https://rachoucorp.app/privacy-moto` actually resolves.

No pre-existing Moto privacy policy was found anywhere in either repo despite
Moto being live on the Play Store since February — worth double-checking the
Play Console's **App content → Privacy policy** field points somewhere valid,
and updating it to this new URL if it was missing or pointed elsewhere.

---

## Repo-side prep already done (this session)

- [x] iOS bundle ID fixed: `com.example.moto` → `com.rachoucorp.moto` (main target + RunnerTests) in `ios/Runner.xcodeproj/project.pbxproj`
- [x] `ITSAppUsesNonExemptEncryption = false` added to `ios/Runner/Info.plist` (Moto only uses standard HTTPS-less local storage + StoreKit — no custom encryption)
- [x] App Store screenshots regenerated at the current required **6.9" (1320×2868)** size — Apple's Media Manager dropped the old 6.5"/6.7" slots since Wingman's launch. Saved at `screenshots/final/appstore-6.9/{en,fr,ja}/` (resized from the existing composited finals via the ASO skill's `resize.py --target appstore-69` — no need to redo the Gemini generation pipeline, the aspect ratio shift was tiny)
- [x] `.github/workflows/ios-build.yml` copied from Wingman (generic build-any-flutter/RN-project workflow, unchanged)
- [x] `builder.json` added (project: moto, repo: Rachoudane/moto)
- [x] `builder-windows-amd64.exe` copied to repo root (same personal MobAI-based tool used for Wingman, not project-specific)
- [x] `scripts/ios-menu.ps1` + `scripts/ios-deploy.ps1` copied and re-labeled for Moto
- [x] `codemagic.yaml` added, adapted (integration name `moto_asc_api_key`, cert/profile reference names `moto_distribution_cert` / `moto_appstore_profile`)
- [x] `dist/*.ipa` added to `.gitignore`

Still missing on the **Apple side** (none of this can be done from the repo):
App Store Connect app record, Distribution certificate + provisioning profile
for `com.rachoucorp.moto`, App Store Connect API key, Codemagic project
connection, subscription group + 3 IAP products, App Privacy questionnaire,
Age Rating, DSA trader info, Pricing & Availability.

---

## 1. Testing on your iPhone during development (MobAI flow)

Same method as Wingman — no Mac needed for day-to-day builds:

1. Run `.\scripts\ios-menu.ps1` from the repo root
2. Option **1) Quick test: build + sign + auto-install** — triggers the
   `ios-build.yml` GitHub Actions workflow (builds an unsigned IPA on
   `macos-latest`), then signs + installs it on your iPhone via MobAI
3. Option **4) Check MobAI / iPhone connectivity** if the install fails —
   confirms MobAI is running and the iPhone is paired

This produces **dev-signed** builds for your own device only. It cannot be
used to test the actual App Store submission candidate — Apple blocks
sideloading of App Store-signed IPAs. For that, use TestFlight (section 12
below), which installs the *exact* build that would be submitted.

---

## 2. Screenshots (Media Manager)

Only the **6.9" Display** slot matters now — Apple auto-generates the rest
from it, and only the first 3 images show on the app install sheet.

Ready at:
- EN: `screenshots/final/appstore-6.9/en/`
- FR: `screenshots/final/appstore-6.9/fr/`
- JA: `screenshots/final/appstore-6.9/ja/`

**Steps:**
1. Media Manager → **iPhone** tab → open the **6.9" Display** box
2. Upload in order (EN, language selector defaults to English (U.S.)):
   `01-grow-squares.jpg`, `02-keep-trophies.jpg`, `03-unlock-badges.jpg`,
   `04-choose-challenge.jpg`, `05-build-break.jpg`, `06-meet-motosan.jpg`
3. Switch language selector to **French** → repeat with the `fr/` set
4. **+ Add Localization → Japanese** → repeat with the `ja/` set
5. Leave every other size box empty

---

## 3. Metadata (English) — on the version page

| Field | Value |
|---|---|
| Name (30 max) | `Moto: Habit Tracker` |
| Subtitle (30 max) | `Grow Habits, Square by Square` |
| Promotional Text (170 max) | See `store/metadata/appstore-en.md` |
| Description (4000 max) | Full text in `store/metadata/appstore-en.md` (~2000 chars) — paste as-is |
| Keywords (100 max) | `habit tracker,streak,daily habits,goal,self improvement,routine,motivation,productivity,checklist` |
| Support URL | `https://rachoucorp.app` or `mailto:rachoucorp@gmail.com` |
| Marketing URL | `https://rachoucorp.app/moto` (optional — the page already exists per `react-portfolio/src/pages/AppLanding.jsx` with `appId="moto"`) |
| Copyright | `2026 Rachou Corp` |
| Version | must match `pubspec.yaml` (currently `1.1.2`) |

---

## 4. French (FR) Localization

**+ Add Localization → French**, fill from `store/metadata/appstore-fr.md`:
Name `Moto : suivi d'habitudes`, Subtitle `Vos habitudes, case par case`,
plus Promotional Text, Description, Keywords. Screenshots done in section 2.

---

## 5. Japanese (JA) Localization

**+ Add Localization → Japanese**, fill from `store/metadata/appstore-ja.md`:
Name `Moto - 習慣トラッカー`, Subtitle `習慣を、一マスずつ育てる`, plus
Promotional Text, Description, Keywords. Screenshots done in section 2.

> Note: Wingman only shipped EN+FR on the App Store — Moto adds Japanese here
> since the app itself supports all 3 locales (`lib/l10n/`).

---

## 6. App Information (left menu, under General)

**Localizable Information**
- Name / Subtitle: per-language, as above

**General Information**
- Bundle ID: `com.rachoucorp.moto` (register this first at
  developer.apple.com/account/resources/identifiers/list, with **In-App
  Purchase** capability enabled, before it appears here)
- SKU: suggest `moto-habit-tracker` (must be unique, never shown to users)
- Content Rights: "No, this app does not contain, show, or access
  third-party content" — Moto is fully original (no licensed IP, unlike
  Wingman's Valorant screenshots)
- Primary Language: English (U.S.)
- Category: Health & Fitness · Secondary (optional): Productivity

Privacy Policy URL goes under **App Privacy** (left menu), not here:
`https://rachoucorp.app/privacy-moto`.

---

## 7. Age Ratings

Same grouped questionnaire as Wingman, but **simpler — no ads means "None"
across the board, including Advertising** (Moto has zero third-party SDKs):

| Group | Answer |
|---|---|
| In-App Controls | None |
| Capabilities (incl. Advertising) | None |
| Mature Themes | None |
| Medical or Wellness | None — habit tracking isn't a medical/health claim, but double-check if Apple's questionnaire has a borderline "Health & Wellness Topics" sub-question given the Health & Fitness category; answer accurately either way |
| Sexuality or Nudity | None |
| Violence | None |
| Chance-Based Activities | None |

Expected result: **4+**.

---

## 8. App Encryption Documentation

Already handled: `ITSAppUsesNonExemptEncryption = false` is now in
`ios/Runner/Info.plist` (done this session). Once a build with this key is
uploaded, App Store Connect won't ask at submission time.

---

## 9. App Store Regulations & Permits

- **DSA**: click **Set Up** if selling in the EU — same trader declaration
  Rachou Corp already did for Wingman (business name, address, phone, email)
- **Vietnam Game License**: skip
- **Regulated Medical Devices**: skip
- **App Store Server Notifications**: skip, unless you later want server-side
  subscription lifecycle webhooks (not required to launch)
- **App-Specific Shared Secret**: only needed if you validate subscription
  receipts server-side. Moto's `iap_service.dart` uses the `in_app_purchase`
  plugin directly against StoreKit with no server component — skip unless
  that changes

---

## 10. App Privacy (left menu → App Privacy)

Moto has **no AdMob, no Firebase/analytics, no user accounts, and no
server** — `shared_preferences` (local only) and `in_app_purchase` (StoreKit
directly) are the only data-adjacent plugins in `pubspec.yaml`. This is
meaningfully simpler than Wingman's AdMob-driven questionnaire.

Likely answer to the first question ("Do you or your third-party partners
collect data from this app?"): **No** — nothing is transmitted off-device to
you or a partner. Verify this against Apple's exact definitions before
submitting (in particular: purchase/subscription state is stored locally via
`shared_preferences`/StoreKit, not sent to a server you control, which is why
this differs from Wingman's AdMob-forced "Yes"). If in doubt, Apple's
guidance is to err toward disclosure — re-check each category (Identifiers,
Usage Data, Diagnostics, Purchases) against what `flutter_local_notifications`,
`permission_handler`, and `in_app_purchase` actually do on iOS before
finalizing.

---

## 11. In-App Purchases — 3 Subscriptions + 1 Non-Consumable

Unlike Wingman's single non-consumable, Moto sells access via subscription
(matches the Play Store setup already live — see `store/guide-playstore.md`):

**Monetization → Subscriptions** (left menu):
1. Create a **Subscription Group** (e.g. "Moto Pro")
2. Add subscription **`moto_pro_yearly`** — must match
   `lib/services/iap_service.dart`'s `yearlyProductId` exactly
3. Add subscription **`moto_pro_monthly`** — matches `monthlyProductId`
4. For each: set duration, price tier, localized display name/description
   (EN/FR/JA), and a Review Screenshot showing the Pro upsell screen
   (`pro_screen.dart`)

**Monetization → In-App Purchases** (non-consumable, like Wingman's Remove Ads):
5. Add **`moto_pro_lifetime`** as a **Non-Consumable** — matches
   `lifetimeProductId`. Same per-field setup as Wingman's Remove Ads IAP
   (Family Sharing off, Availability, Price Schedule, Localization, Review
   Screenshot, Review Notes)

> Note: `restorePurchases()` is already implemented in `iap_service.dart` and
> wired to a button in `pro_screen.dart` — Apple guideline 3.1.1 requires
> this for any non-consumable/subscription and it's already covered.

None of these can be submitted standalone — they attach to and submit
together with the first app version (see section 15).

---

## 12. Pricing and Availability

- **Price**: Free (app itself; subscriptions/IAP priced separately above)
- **Availability**: match whatever was chosen for the Play Store listing

---

## 13. Paid Applications Agreement, Banking & Tax

Required in App Store Connect (**Agreements, Tax, and Banking**) before any
paid IAP/subscription can go live — fill this in if Wingman's non-consumable
already triggered it for this account; otherwise it's a one-time setup.

---

## 14. Build Upload — via Codemagic

Setup mirrors Wingman's working pipeline (`codemagic.yaml` already added to
this repo):

1. In Codemagic, add the `Rachoudane/moto` repo, switch workflow to
   **"codemagic.yaml"**
2. Generate (or reuse, if the account/team is the same) an **App Store
   Connect API Key** with role **Admin** → add under Codemagic Team settings
   → Integrations → App Store Connect, named `moto_asc_api_key` to match
   `codemagic.yaml`
3. Try **automatic signing** first (comment in `codemagic.yaml` explains
   why) — if it fails with "No matching profiles found" like it did for
   Wingman, switch to manual:
   - Generate a CSR (a new one, or reuse Wingman's private key if you still
     have it — the **Distribution certificate itself can be reused across
     apps on the same team**, only the provisioning profile is per-bundle-ID)
   - Create an **Apple Distribution** certificate (if not reusing Wingman's)
   - Create an **App Store Connect** provisioning profile for
     `com.rachoucorp.moto` + that certificate
   - Upload under Codemagic **Team settings → Code signing identities** as
     `moto_distribution_cert` / `moto_appstore_profile`
4. First successful build uploads to App Store Connect and processes
   automatically
5. Add yourself as an internal TestFlight tester, install via the TestFlight
   app — this is the real submission candidate, not the MobAI dev build

**Certificate expiry**: if reusing Wingman's cert, it expires **2027-07-15**.

---

## 15. App Review Information

- **Sign-in required**: No
- **Notes for reviewer** (draft):
  ```
  This is a habit-tracking app with local data storage only (no server,
  no accounts). Users track daily habits and build streaks visualized as
  a growing square grid. Subscriptions (Pro tier) unlock unlimited habits
  and full history; a free tier (up to 3 habits) is fully functional
  without payment. No ads, no third-party SDKs.
  ```

---

## 16. Submit for Review

1. **App Store Version Release**: Manually release this version
2. **Add for Review** / **Submit for Review**
3. Review time: typically 24–72 hours

---

## Key URLs

| Resource | URL |
|---|---|
| App Store Connect | https://appstoreconnect.apple.com |
| Certificates, IDs & Profiles | https://developer.apple.com/account/resources/identifiers/list |
| App Review Guidelines | https://developer.apple.com/app-store/review/guidelines/ |
| Privacy Policy | **TBD — see ⚠️ note at top** |
| Play Store listing (live reference) | https://play.google.com/store/apps/details?id=com.rachoucorp.moto |
