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
> - **Name, Subtitle, and Promotional Text are gone from the version panel**
>   — not per-locale here anymore. Best guess: Name/Subtitle moved to
>   `App Information`; Promotional Text is likely behind a separate
>   quick-edit control Apple added since it's now editable without review.
>   **Not yet confirmed** — see the note at the end of section 4.
>
> Sections 3, 4, 6b, 16, 17 below are now confirmed field-by-field from
> screenshots. Sections 7–9 (App Information / Age Ratings / Encryption)
> still describe the pre-redesign fields and need one more screenshot pass
> to confirm — flag it when you get there.

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
| Description (4,000 max) | Full text in `store/metadata/appstore-en.md` (~2000 chars) — paste as-is |
| Keywords (100 max) | `habit tracker,streak,daily habits,goal,self improvement,routine,motivation,productivity,checklist` |
| Support URL | `https://rachoucorp.app` or `mailto:rachoucorp@gmail.com` |
| Marketing URL | `https://rachoucorp.app/moto` (optional) |
| Version | must match `pubspec.yaml` (currently `1.1.2`) — pre-filled `1.0` right now, needs updating |
| Copyright (200 max) | `2026 Rachou Corp` |
| Routing App Coverage File | leave empty — this is for App Clips only, Moto doesn't have one |

Below that, two **collapsed** sections — leave both closed, Moto uses
neither: **App Clip** and **iMessage App**.

**No "Name" or "Subtitle" fields, and no "Promotional Text" field appear on
this page anymore** — confirmed absent between the language selector and
Description in the actual screenshot. Two live changes from Apple in
2025–2026 explain this:
- **Name/Subtitle** moved to the `App Information` page (section 7) — they
  used to be per-version/per-locale here, now they're managed there instead.
- **Promotional Text** still exists as a field (Apple's own docs still
  describe it as "the only field editable without review") but isn't on
  this full edit form anymore — it's very likely behind a lighter-weight
  quick-edit control (e.g. a pencil icon on the live product page preview,
  or inside `Product Page Optimization` under Growth & Marketing). Not yet
  confirmed by screenshot — check both `App Information` and
  `Product Page Optimization` when you get there and tell me which one has
  it, plus the exact Name/Subtitle field labels/limits you see on
  `App Information`, since section 7 below is still describing the *old*
  fields for that page.

---

## 5. French (FR) Localization

Still on that version panel: switch the language selector to **French**
(or **+ Add Localization → French** if not yet added), fill Description /
Keywords from `store/metadata/appstore-fr.md`. Screenshots done in
section 3. (Name/Subtitle/Promotional Text: see the note at the end of
section 4 — not on this page, still being tracked down.)

---

## 6. Japanese (JA) Localization

Still on that version panel: **+ Add Localization → Japanese**, fill
Description / Keywords from `store/metadata/appstore-ja.md`. Screenshots
done in section 3. (Name/Subtitle/Promotional Text: same caveat as above.)

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

Confirmed from the sidebar: it's a left-menu item under the **General**
group (alongside `App Review` and `History`), not a top-level tab.

**General Information**
- Bundle ID / SKU: already set from section 2, read-only here
- Content Rights: "No, this app does not contain, show, or access
  third-party content" — Moto is fully original (no licensed IP, unlike
  Wingman's Valorant screenshots)
- Primary Language: English (U.S.)
- Category: Health & Fitness · Secondary (optional): Productivity

Age Ratings and App Encryption Documentation are sub-sections of this same
`App Information` page (sections 8/9 below). Privacy Policy URL and the
data-collection questionnaire, however, are on their **own** sidebar item,
`App Privacy` (section 11) — confirmed separate, not nested here.

---

## 8. Age Ratings

Apple replaced the old grouped questionnaire with a multi-step **"Set Up
Age Ratings"** dialog, reachable via the `App Information` page from
section 7 (Distribution tab → sidebar → General → App Information → Age
Ratings → **Set Up Age Ratings** button) — not yet confirmed by screenshot,
flag it to me if it's actually somewhere else. Separately, Apple added new
rating tiers. Apple required
every app to re-answer the updated questionnaire by **January 31, 2026**,
which has already passed, so this step is mandatory even for the initial
submission, not optional boilerplate:

**New tiers:** `4+`, `9+`, `13+`, `16+`, `18+` (replacing the old
4+/9+/12+/17+ scale).

**Dialog flow:**
1. Step 1 — select any **in-app controls / capabilities** that can restrict
   content (Moto has none: no chat, no user-generated content, no
   unrestricted web access)
2. Steps 2–6 — a series of content-descriptor questions, each answered with
   **None / Infrequent/Mild / Frequent/Intense** rather than a flat
   yes/no — for Moto, **None** across every category (Mature Themes,
   Sexuality, Violence, Chance-Based Activities/Gambling, etc.), same
   reasoning as before: no ads, no third-party SDKs, no gambling mechanics
3. Final step — Apple shows a **Calculated Rating**, plus:
   - **Age Category Override**: leave **Not Applicable** (don't opt into
     "Made for Kids" — Moto isn't a kids' app)
   - **Age Suitability URL** (optional): leave blank unless you want a page
     explaining the rating

Expected calculated result: **4+**. Double-check the Health & Fitness
category doesn't trigger a borderline "Medical/Treatment Information"
descriptor — answer accurately either way if it appears.

---

## 9. App Encryption Documentation

Already handled: `ITSAppUsesNonExemptEncryption = false` is now in
`ios/Runner/Info.plist` (done this session). Once a build with this key is
uploaded, App Store Connect won't ask at submission time. If it does still
prompt, it's most likely a field on the same `App Information` page from
section 7 (not yet confirmed by screenshot) or a submission-time question —
answer "No" to using non-exempt encryption either way.

---

## 10. App Store Regulations & Permits

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

## 11. App Privacy (Distribution tab → sidebar → App Store → Trust & Safety → App Privacy)

Confirmed from the sidebar: its own left-menu item, grouped under
**App Store → Trust & Safety** alongside `App Accessibility` and
`Ratings and Reviews` — not nested inside App Information. Fields:

- **Privacy Policy URL** (required): `https://rachoucorp.app/privacy-moto`
- **User Privacy Choices URL** (optional, newer field): leave blank — this
  is for apps that offer an in-app privacy/data-deletion self-service flow,
  which Moto doesn't need since nothing is collected in the first place
- **Data Types** questionnaire: same as before

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
(matches the Play Store setup already live — see `store/guide-playstore.md`):

Sidebar path confirmed for the group: **Distribution tab → sidebar →
App Store → Monetization**, containing (in this exact order, confirmed by
screenshot): `Pricing and Availability` (section 13), `In-App Purchases`,
`Subscriptions`.

**Monetization → Subscriptions**:
1. Create a **Subscription Group** (e.g. "Moto Pro")
2. Add subscription **`moto_pro_yearly`** — must match
   `lib/services/iap_service.dart`'s `yearlyProductId` exactly
3. Add subscription **`moto_pro_monthly`** — matches `monthlyProductId`
4. For each: set duration, price tier, localized display name/description
   (EN/FR/JA), and a Review Screenshot showing the Pro upsell screen
   (`pro_screen.dart`)

**Monetization → In-App Purchases** (same sidebar group, non-consumable, like Wingman's Remove Ads):
5. Add **`moto_pro_lifetime`** as a **Non-Consumable** — matches
   `lifetimeProductId`. Same per-field setup as Wingman's Remove Ads IAP
   (Family Sharing off, Availability, Price Schedule, Localization, Review
   Screenshot, Review Notes)

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
