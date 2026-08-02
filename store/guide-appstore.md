# App Store Connect — Publication Guide (Moto)

> Adapted from [[project-wingman]]'s App Store setup (`wingman/store/guide-appstore.md`) —
> same Apple Developer account/team (Rachou Corp), same Codemagic + MobAI method,
> different app specifics (3 subscriptions instead of 1 non-consumable, EN+FR+JA
> instead of EN+FR, no ads/AdMob at all).
>
> Status: **SUBMITTED FOR REVIEW** — iOS App 1.1.2 (5), submitted 2026-08-02,
> "Waiting for Review". Full pipeline built and verified end-to-end this
> session: App ID + App Store Connect record created, screenshots/metadata/
> age rating/app privacy/pricing/IAP filled in (sections 3–14), Codemagic
> wired up reusing Wingman's App Store Connect API key + distribution
> certificate (new provisioning profile for `com.rachoucorp.moto`), first
> Codemagic build succeeded and uploaded to TestFlight (build 5, "Ready to
> Submit" — the red "App Store distribution" post-processing failure was the
> same known cosmetic issue as Wingman's, not a real blocker), App Review
> Information filled in, submitted with "Manually release this version".
> Next: wait for Apple's review, then manually release once approved.

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
sideloading of App Store-signed IPAs. For that, use TestFlight (section 15
below), which installs the *exact* build that would be submitted.

---

## 2. Register the app (App ID + App Store Connect record)

Nothing exists yet on Apple's side for Moto — this is the actual first step,
before Media Manager/metadata/anything else below is even reachable.

1. **developer.apple.com/account/resources/identifiers/list** → **+** →
   App IDs → App:
   - Description: `Moto`
   - Bundle ID: **Explicit** → `com.rachoucorp.moto`
   - Capabilities: check **In-App Purchase**
   - Register
2. **appstoreconnect.apple.com → Apps (top nav) → + → New App**:
   - Platform: iOS
   - Name: `Moto: Habit Tracker` (must be globally unique across the whole
     App Store — check availability; fall back to a variant if taken)
   - Primary Language: English (U.S.)
   - Bundle ID: select `com.rachoucorp.moto` from the dropdown (populated
     from step 1 — if it's not there yet, the App ID registration hasn't
     propagated, wait a minute and refresh)
   - SKU: `moto-habit-tracker` (internal only, never shown publicly)
   - User Access: Full Access
   - Create
3. This creates the app record, opening on the **Distribution** tab with a
   first version already scaffolded (shown in the sidebar as
   `1.0 Prepare for Submission`) — click it to reach the Screenshots/Metadata
   panel (sections 3–4). App Information, App Privacy, Age Ratings,
   Encryption, Regulations and Pricing all live in the left sidebar next to
   it, not on the version panel itself (sections 7–13)

---

> **Interface note (2026, confirmed from a live screenshot of the Moto app
> record):** Apple rolled out **App Store Connect 2.0** (Nov 2024) and the
> flat left-hand version-page menu this guide originally described no
> longer exists. Actual current layout:
>
> - Top tab bar on the app record: **Distribution** (default) | Analytics |
>   TestFlight | Xcode Cloud
> - Inside **Distribution**, a left sidebar with three groups (all
>   confirmed by screenshot):
>   - **iOS App** — the version itself, shown as e.g. `1.0 Prepare for
>     Submission` (status dot + label) + an **Add Platform** link. Clicking
>     the version opens the main panel: Screenshots → Description/Keywords/
>     Support+Marketing URL/Version/Copyright → App Clip/iMessage App
>     (collapsed) → Build → In-App Purchases & Subscriptions banner → Game
>     Center → App Review Information → App Store Version Release (sections
>     3, 4, 6b, 16, 17)
>   - **General** — `App Information`, `App Review`, `History`
>   - **App Store**, split into three subgroups:
>     - **Trust & Safety** — `App Privacy`, `App Accessibility`,
>       `Ratings and Reviews`
>     - **Growth & Marketing** — `In-App Events`, `Custom Product Pages`,
>       `Product Page Optimization`, `Promo Codes`, `Game Center`
>     - **Monetization** — `Pricing and Availability`, `In-App Purchases`,
>       `Subscriptions` (this exact order)
>     - **Featuring** — `Nominations` (not relevant to Moto)
> - The version panel itself keeps the **Save** / **Add for Review** buttons
>   top-right, sticky the whole time you scroll — unchanged from the old flow.
> - **Name and Subtitle are gone from the version panel** — moved to the
>   `App Information` page instead (section 7). Promotional Text is still
>   on the version panel as before (right after Screenshots).
> - **`App Information` is one long page**, not split into further sidebar
>   items — Age Ratings, App Encryption Documentation, and App Store
>   Regulations & Permits (DSA/Vietnam/Medical Devices/Server
>   Notifications/Shared Secret) are all just sections you scroll past on
>   that same page, confirmed by screenshot. Old sections 8/9/10 below are
>   rewritten to reflect this — they're not separate destinations.
>
> Sections 3, 4, 6b, 7, 8, 9, 10, 11, 16, 17 are now confirmed field-by-field
> from screenshots. Section 12 now has precise, current product IDs,
> pricing, and per-locale copy (sourced from `iap_service.dart` and
> `lib/l10n/*.arb`), but its on-page UI layout is still not
> screenshot-verified against App Store Connect 2.0. Remaining unconfirmed:
> section 13 (Pricing and Availability) and 14/15 (Agreements/Tax/Banking,
> Codemagic build upload) — same content as before, just not yet
> screenshot-verified against the new UI.

## 3. Screenshots (version panel → Previews and Screenshots)

Only the **6.9" Display** slot matters now — Apple auto-generates the rest
from it, and only the first 3 images show on the app install sheet.

Ready at:
- EN: `screenshots/final/appstore-6.9/en/`
- FR: `screenshots/final/appstore-6.9/fr/`
- JA: `screenshots/final/appstore-6.9/ja/`

**Steps (matches the live UI as of this writing):**
1. Distribution tab → sidebar → click the version (`1.0 Prepare for
   Submission`) → language selector top-right defaults to **English
   (U.S.)** → scroll to **Previews and Screenshots**
2. Under the **iPhone** sub-tab (also has iPad / Apple Watch sub-tabs),
   there's a single box currently labeled **"iPhone 6.5" Display"** with a
   smaller **"Using 6.9" Display"** note and an **Edit** link — that Edit
   link (or the **View All Sizes in Media Manager** link top-right of the
   Previews and Screenshots section) is where you actually upload
3. Upload in order: `01-grow-squares.jpg`, `02-keep-trophies.jpg`,
   `03-unlock-badges.jpg`, `04-choose-challenge.jpg`, `05-build-break.jpg`,
   `06-meet-motosan.jpg` — the box footer shows a running count, e.g.
   `6 of 10 Screenshots` (10 is the max Apple allows per size; only 6 are
   used) and `0 of 3 App Previews` (video previews — Moto has none, leave
   at 0)
4. Switch the language selector (top-right) to **French** → repeat with the
   `fr/` set
5. **+ Add Localization → Japanese** (from the sidebar version entry, or
   the language selector's "Add Localization" option) → repeat with the
   `ja/` set
6. Leave iPad and Apple Watch sub-tabs empty (Moto is iPhone-only)

---

## 4. Metadata (English) — same version panel, below Screenshots

Confirmed field-by-field from a live screenshot. Immediately below
**Previews and Screenshots**, in this exact order:

| Field | Value |
|---|---|
| Promotional Text (170 max) | See `store/metadata/appstore-en.md` |
| Description (4,000 max) | Full text in `store/metadata/appstore-en.md` (~2000 chars) — paste as-is |
| Keywords (100 max) | `habit tracker,streak,daily habits,goal,self improvement,routine,motivation,productivity,checklist` |
| Support URL | `https://rachoucorp.app` or `mailto:rachoucorp@gmail.com` |
| Marketing URL | `https://rachoucorp.app/moto` (optional) |
| Version | must match `pubspec.yaml` (currently `1.1.2`) — pre-filled `1.0` right now, needs updating |
| Copyright (200 max) | `2026 Rachou Corp` |
| Routing App Coverage File | leave empty — this is for App Clips only, Moto doesn't have one |

Below that, two **collapsed** sections — leave both closed, Moto uses
neither: **App Clip** and **iMessage App**.

**Correction:** Promotional Text is on this page after all (right below
Screenshots, above Description) — an earlier pass of this guide wrongly
said it was missing based on a screenshot boundary that just happened to
cut off right above it. What *is* genuinely gone from this page: **Name**
and **Subtitle** — confirmed moved to the `App Information` page, see the
rewritten section 7 below.

---

## 5. French (FR) Localization

Still on that version panel: switch the language selector to **French**
(or **+ Add Localization → French** if not yet added), fill Promotional
Text / Description / Keywords from `store/metadata/appstore-fr.md`.
Screenshots done in section 3. (Name/Subtitle for French: set on the
`App Information` page instead, section 7 — its own language selector.)

---

## 6. Japanese (JA) Localization

Still on that version panel: **+ Add Localization → Japanese**, fill
Promotional Text / Description / Keywords from `store/metadata/appstore-ja.md`.
Screenshots done in section 3. (Name/Subtitle for Japanese: section 7.)

> Note: Wingman only shipped EN+FR on the App Store — Moto adds Japanese here
> since the app itself supports all 3 locales (`lib/l10n/`).

---

## 6b. Build, In-App Purchases banner, Game Center — same version page, not per-locale

Below the localized fields (still scrolling the same version page, applies
regardless of which language is selected):

**Build**
- An info banner: *"If your app uses encryption, you're required to upload
  export compliance documentation. You can submit this documentation before
  you submit your app for review in the **App Encryption Documentation
  section**, or by uploading your app below."* — that linked section lives
  on the `App Information` page (section 7/9), confirmed via Apple's docs:
  `App Information` → next to **App Encryption Documentation** → **+** to
  answer questions/upload docs. Since Moto already ships
  `ITSAppUsesNonExemptEncryption = false` in `Info.plist`, this should
  resolve automatically once a build is uploaded — verify there's nothing
  to fill in manually.
- Below that: an empty box — *"Upload your builds using one of several
  tools. See Upload Tools"*. This is where the Codemagic-built IPA shows up
  once processed (section 15).

**In-App Purchases and Subscriptions**
- Just an info banner here, not the actual management UI: *"In-app
  purchases and subscriptions can now be submitted for review from the
  In-App Purchases and Subscriptions sections. Include an app version in
  your submission to have items reviewed together. Your first in-app
  purchase and subscription must be submitted with a new app version."*
- Confirms section 12's plan: actually create/manage the 3 subscriptions +
  1 non-consumable on their own sidebar pages (`App Store → Monetization →
  In-App Purchases` / `Subscriptions`, sidebar order confirmed in that
  order), **not** from this version page — but the first one of each
  **must** be attached to this first app version's submission to go live
  together.

**Game Center**
- A checkbox, but disabled for direct use: *"Game Center components can now
  be added for review directly from the Game Center section. You can no
  longer select them from the app version page."* — irrelevant to Moto,
  leave unchecked.

---

## 7. App Information (Distribution tab → sidebar → General → App Information)

Confirmed field-by-field from screenshots. It's a left-menu item under
**General** (alongside `App Review` and `History`), and it's **one long
page** — sections 8, 9, 10 below are just further down this same page, not
separate destinations. Header note Apple shows: *"This information is used
for all platforms of this app. Any changes will be released with your next
app version."*

**Localizable Information** (own language selector, top-right):
| Field | Value |
|---|---|
| Name | `Moto: Habit Tracker` |
| Subtitle | `Grow Habits, Square by Square` |

Switch the selector to French/Japanese and fill the localized name/subtitle
from `store/metadata/appstore-fr.md` / `appstore-ja.md` here (this is what
moved off the version panel — see sections 4–6).

**General Information** (two columns):
- Bundle ID: dropdown, already shows `Moto - com.rachoucorp.moto`
- SKU: `moto-habit-tracker`, read-only
- **Apple ID**: a numeric ID Apple assigns (e.g. `6797039104` shown in the
  screenshot) — read-only, but worth noting down once created, useful for
  App Store Connect API calls / TestFlight public links later
- **Content Rights**: no longer a radio/text choice — now an **Edit** link
  opening a **"Set Up Content Rights Information"** flow. Go through it and
  answer that Moto doesn't contain third-party content (fully original, no
  licensed IP, unlike Wingman's Valorant screenshots)
- **License Agreement**: an **Edit** link, defaults to **Apple's Standard
  License Agreement** — leave as default, no need for a custom EULA
- Primary Language: English (U.S.)
- Category: Primary `Health & Fitness` · Secondary (optional) `Productivity`

---

## 8. Age Ratings

Still on the `App Information` page (section 7), scrolled further down.
Apple replaced the old grouped questionnaire with a **"Set Up Age
Ratings"** button that opens a multi-step dialog, plus added new rating
tiers. Apple required every app to re-answer the updated questionnaire by
**January 31, 2026**, which has already passed, so this is mandatory for
the initial submission:

**New tiers:** `4+`, `9+`, `13+`, `16+`, `18+` (replacing the old
4+/9+/12+/17+ scale).

Confirmed from screenshot, the page shows a **"Set Up Age Ratings"** button,
then a **"Learn More About Age Ratings"** reference grid with exactly these
7 categories (note: **no separate "Advertising" category anymore** — it's
gone or folded elsewhere):
- **In-App Controls** — Parental Controls, Age Assurance
- **Capabilities** — Unrestricted Web Access, User-Generated Content,
  Social Media, Social Media Disabled for Users...
- **Mature Themes** — Profanity or Crude Humor, Horror/Fear Themes,
  Alcohol, Tobacco, or Drug Use or References
- **Medical or Wellness** — Medical or Treatment Information, Health or
  Wellness Topics
- **Sexuality or Nudity** — Mature or Suggestive Themes, Sexual Content or
  Nudity, Graphic Sexual Content and Nudity
- **Violence** — Cartoon or Fantasy Violence, Realistic Violence, Prolonged
  Graphic or Sadistic Realistic...
- **Chance-Based Activities** — Gambling, Simulated Gambling, Contests,
  Loot Boxes

These are reference cards, not the actual questionnaire — the real flow is
behind **Set Up Age Ratings**, still expected to be the same multi-step
None/Infrequent/Frequent dialog described by Apple's help docs. For Moto:
**None** across every category — no chat, no user-generated content, no
gambling mechanics, no third-party SDKs. Watch **Medical or Wellness**
specifically: it's called out by name here given Moto's Health & Fitness
category — answer accurately (habit tracking isn't medical/treatment
advice, so should be None, but check the actual sub-questions).

Expected calculated result: **4+**.

---

## 9. App Encryption Documentation

Still the same `App Information` page, right after Age Ratings. Confirmed
text: *"Specify your use of encryption in Xcode by adding the **App Uses
Non-Exempt Encryption** key to your app's Info.plist file with a Boolean
value that indicates whether your app uses encryption."* Then lists when
documentation is required:
- Encryption algorithms that are proprietary or not accepted as standard by
  international standard bodies (IEEE, IETF, ITU, etc.)
- Standard encryption algorithms instead of, or in addition to, using or
  accessing the encryption within Apple's operating system

Since `ITSAppUsesNonExemptEncryption = false` is already set in
`ios/Runner/Info.plist` (done this session) and Moto only uses standard
HTTPS/StoreKit — neither bullet applies, so there's nothing to upload here.
The page shows an **Upload** button (*"You can provide your documentation
before you submit a build"*) — leave it untouched; the `Info.plist` key
should make App Store Connect skip asking again once a build is processed.

---

## 10. App Store Regulations & Permits

Still the same `App Information` page, right after App Encryption
Documentation. Confirmed sections and exact current copy:

- **Digital Services Act**: already shows *"This developer has identified
  itself as a trader for this app"* with an **Edit** link and an
  **Add Labels and Markings** link — the Wingman-era trader declaration
  already covers Moto (this is account/team-level, not per-app), nothing
  to newly set up. Only revisit **Add Labels and Markings** if a specific
  product needs one (Moto doesn't).
- **Vietnam Game License**: box says *"If your game is available on the App
  Store in Vietnam, you can add a game license..."* with an **Add**
  link — skip, Moto isn't a game and isn't specifically targeting Vietnam.
- **Regulated Medical Devices**: **this is not skippable the way the old
  guide assumed** — the box explicitly says *"If your app is in the
  Medical or Health and Fitness categories... you need to declare whether
  it functions as a regulated medical device to keep distributing on the
  App Store in certain regions"*, with a **Declare Regulated Medical
  Device** link. Since Moto's category is Health & Fitness, click through
  and declare **No, it does not function as a regulated medical device**
  (a habit tracker makes no medical claims) — but the declaration itself
  must be made, not skipped.
- **App Store Server Notifications**: Production/Sandbox Server URL, both
  **Set Up URL** — skip, no server-side subscription lifecycle webhooks
  needed
- **App-Specific Shared Secret**: a **Manage** link — skip, Moto's
  `iap_service.dart` uses `in_app_purchase` directly against StoreKit with
  no server component

Below that: an **Additional Information** block (`View on App Store`,
`Edit User Access`, `Remove App`) — nothing to do here.

---

## 11. App Privacy (Distribution tab → sidebar → App Store → Trust & Safety → App Privacy)

Confirmed field-by-field from screenshot. Own left-menu item, grouped under
**App Store → Trust & Safety** alongside `App Accessibility` and
`Ratings and Reviews`. Top of page has a **Publish** button (separate from
the version's Save/Add for Review) and its own language selector.

**Privacy Policy** section (with an **Edit** link next to the heading —
the URLs below aren't directly editable inline, click Edit to set them):
| Field | Value |
|---|---|
| Privacy Policy URL | `https://rachoucorp.app/privacy-moto` (currently empty — shows `—`) |
| User Privacy Choices URL (Optional) | leave empty — for apps offering in-app data-deletion/opt-out self-service, which Moto doesn't need |

Below that, a **"Get Started"** button (data questionnaire not yet begun),
with Apple's framing text: *"The App Store is designed to be a safe and
trusted place... After clicking Get Started, you'll be asked to provide
some information about your app's data collection practices."* Click
**Get Started** to reach the actual Data Types questionnaire (same
substance as before, just gated behind this button first).

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

## 12. In-App Purchases — 3 Subscriptions + 1 Non-Consumable

Unlike Wingman's single non-consumable, Moto sells access via subscription
(matches the Play Store setup already live — see `store/guide-playstore.md`,
same 3 product IDs: `moto_pro_yearly`, `moto_pro_monthly`,
`moto_pro_lifetime`). **Not yet confirmed by screenshot** — the sidebar path
and field structure below are Apple's current documented flow, but the
exact on-page layout hasn't been screenshot-verified against App Store
Connect 2.0 the way sections 3/4/7–11 have. The **product IDs, pricing, and
localized copy** below, however, are pulled directly from the live app
(`iap_service.dart`, `lib/l10n/*.arb`) and the historical Play Store price
points, so treat those as accurate regardless of the UI-layout caveat.

Sidebar path confirmed for the group: **Distribution tab → sidebar →
App Store → Monetization**, containing (in this exact order, confirmed by
screenshot): `Pricing and Availability` (section 13), `In-App Purchases`,
`Subscriptions`.

### Pricing — match the live Play Store price points

Moto's subscriptions have been sold at these EUR price points since launch
(the app used to hardcode them for display before switching to
store-fetched dynamic pricing in Feb 2026, commit `9f352db` — same numbers,
just no longer hardcoded client-side):

| Product | Duration | Reference price (EUR) | Notes |
|---|---|---|---|
| `moto_pro_monthly` | 1 month | **€2.99** | |
| `moto_pro_yearly` | 1 year | **€19.99** | ≈ €1.66/month, ~44% cheaper than paying monthly |
| `moto_pro_lifetime` | one-time | **€39.99** | non-consumable, not a subscription |

App Store Connect prices subscriptions/IAP via **Apple's price tier system**,
not a free-text field: you pick a starting price in your primary
territory's currency (USD, since Primary Language is English (U.S.)) from
Apple's fixed list of price points, and it auto-generates the equivalent
price in every other territory/currency (including EUR) using Apple's own
conversion table — you don't set the EUR price directly. When picking the
USD starting price for each product, choose the tier whose **EUR-equivalent
column** (shown in the price-picker UI) lands closest to €2.99 / €19.99 /
€39.99 respectively, so pricing stays consistent with the Play Store listing
rather than matching the USD number literally. **Double-check the current
live Play Console price for all 3 products before doing this** — if pricing
was ever adjusted since the Feb 2026 launch, `store/guide-playstore.md`
section 4 or the Play Console itself is the source of truth, not this table.

### Localized copy — Display Name + Description per product per locale

Each product needs its own **App Store Localization** per locale (Display
Name shown in the system purchase sheet, Description shown on the product
page) — these are separate from the app's own Name/Subtitle (section 7) and
from `store/metadata/appstore-*.md`. Suggested copy below reuses the app's
own `yearly`/`monthly`/`lifetimeOffer` and `proPromoCardSubtitle` strings
from `lib/l10n/*.arb` for consistency between the purchase sheet and the
in-app upgrade screen (`pro_screen.dart`). Apple's documented field limits:
**Display Name 30 chars max, Description 45 chars max** — not yet
screenshot-confirmed against the 2.0 UI, so re-check the actual limit shown
on the field before pasting.

**Subscription Group Display Name** (shown in the user's Manage
Subscriptions screen, one value per locale, same across both subscriptions
in the group):
| Locale | Value |
|---|---|
| EN | `Moto Pro` |
| FR | `Moto Pro` |
| JA | `Moto Pro` |

**`moto_pro_yearly`**:
| Locale | Display Name | Description |
|---|---|---|
| EN | `Pro Yearly` | `Unlimited habits, full history, and more.` |
| FR | `Pro Annuel` | `Habitudes illimitées, historique complet.` |
| JA | `Pro 年間` | `無制限の習慣、完全な履歴など。` |

**`moto_pro_monthly`**:
| Locale | Display Name | Description |
|---|---|---|
| EN | `Pro Monthly` | `Unlimited habits, full history, and more.` |
| FR | `Pro Mensuel` | `Habitudes illimitées, historique complet.` |
| JA | `Pro 月間` | `無制限の習慣、完全な履歴など。` |

**`moto_pro_lifetime`** (non-consumable):
| Locale | Display Name | Description |
|---|---|---|
| EN | `Pro Lifetime` | `One-time purchase. Unlimited habits, forever.` |
| FR | `Pro à vie` | `Achat unique. Habitudes illimitées à vie.` |
| JA | `Pro 永久` | `買い切り。無制限の習慣を、永久に。` |

Full feature list to draw on for Review Notes or longer descriptions if
needed (`lib/l10n/app_en.arb`, `proFeature1`–`5`): unlimited habits, all
penalty modes (Zen/Standard/Hardcore), complete history & calendar, custom
per-habit notifications, future updates & themes.

**Monetization → Subscriptions**:
1. Create a **Subscription Group** — reference name e.g. "Moto Pro" (internal
   only, not shown to users), then set the Subscription Group Display Name
   per locale from the table above
2. Add subscription **`moto_pro_yearly`** — must match
   `lib/services/iap_service.dart`'s `yearlyProductId` exactly; Duration
   1 year; price per the table above; localized Display Name/Description
   for EN/FR/JA from the table above; Review Screenshot showing the Pro
   upsell screen (`pro_screen.dart`)
3. Add subscription **`moto_pro_monthly`** — matches `monthlyProductId`;
   Duration 1 month; same pattern

**Monetization → In-App Purchases** (same sidebar group, non-consumable, like Wingman's Remove Ads):
4. Add **`moto_pro_lifetime`** as a **Non-Consumable** — matches
   `lifetimeProductId`. Same per-field setup as Wingman's Remove Ads IAP:
   Family Sharing off (Moto's other two products are per-account
   subscriptions, keep the lifetime unlock consistent with that — don't
   let one purchase cover a whole Family Sharing group for free), price per
   the table above, localized Display Name/Description from the table
   above, Review Screenshot, Review Notes

> Note: `restorePurchases()` is already implemented in `iap_service.dart` and
> wired to a button in `pro_screen.dart` — Apple guideline 3.1.1 requires
> this for any non-consumable/subscription and it's already covered.

None of these can be submitted standalone — they attach to and submit
together with the first app version (see section 17).

---

## 13. Pricing and Availability (Distribution tab → sidebar → App Store → Monetization → Pricing and Availability)

Confirmed exact sidebar label from the screenshot.

- **Price**: Free (app itself; subscriptions/IAP priced separately above)
- **Availability**: match whatever was chosen for the Play Store listing

---

## 14. Paid Applications Agreement, Banking & Tax

Required in App Store Connect (**Agreements, Tax, and Banking**) before any
paid IAP/subscription can go live — fill this in if Wingman's non-consumable
already triggered it for this account; otherwise it's a one-time setup.

---

## 15. Build Upload — via Codemagic

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

## 16. App Review Information

Confirmed from screenshot: still the **same version page** as sections
3–4/6b, further down, below Build/IAP-banner/Game Center. Two sub-blocks:

**Sign-In Information**
- A **"Sign-in required"** checkbox — **on by default, must be manually
  unchecked** for Moto (no accounts at all). If left checked, the
  User name / Password fields next to it become required.

**Contact Information** (new — not in the old flat-menu version of this
guide)
- First name / Last name / Phone number / Email — fill these in, this is
  who Apple's reviewer contacts if they have questions. Use your own or
  `rachoucorp@gmail.com`.

**Notes** (4,000 max) — draft:
```
This is a habit-tracking app with local data storage only (no server,
no accounts). Users track daily habits and build streaks visualized as
a growing square grid. Subscriptions (Pro tier) unlock unlimited habits
and full history; a free tier (up to 3 habits) is fully functional
without payment. No ads, no third-party SDKs.
```

**Attachment** (optional) — a "Choose File (Optional)" upload, leave empty
unless you want to attach a demo video/screenshot walkthrough.

---

## 17. Submit for Review

Still the same version page, immediately below section 16 — this is the
literal end of the page (site footer follows). The **"Add for Review"**
button is not part of this bottom section — it's a separate, sticky button
top-right of the version panel (next to **Save**), present the whole time
you scroll.

**App Store Version Release** (bottom of page) — 3 radio options,
confirmed from screenshot:
- **Manually release this version** ← pick this one, keeps control over
  launch timing
- Automatically release this version (was pre-selected by default —
  switch away from it)
- Automatically release this version after App Review, no earlier than
  *[date/time picker]* — not needed here

**Steps:**
1. On the version panel (`1.0 Prepare for Submission`), make sure
   Screenshots, Description/Keywords (sections 3–6), the encryption/build
   info (6b), App Review Information (16), and **Manually release this
   version** (above) are all set
2. Click **Add for Review** (top-right, next to Save)
3. Track status via the sidebar's **App Review** item (General group,
   section 7) — also where any App Review clarification messages show up
4. Review time: typically 24–72 hours

---

## Key URLs

| Resource | URL |
|---|---|
| App Store Connect | https://appstoreconnect.apple.com |
| Certificates, IDs & Profiles | https://developer.apple.com/account/resources/identifiers/list |
| App Review Guidelines | https://developer.apple.com/app-store/review/guidelines/ |
| Age Ratings (current, post-2.0) | https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating |
| App Privacy (current, post-2.0) | https://developer.apple.com/help/app-store-connect/reference/app-information/app-privacy/ |
| Submissions to App Review (current) | https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-for-review |
| Privacy Policy | https://rachoucorp.app/privacy-moto |
| Play Store listing (live reference) | https://play.google.com/store/apps/details?id=com.rachoucorp.moto |
