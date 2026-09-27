# DoneStreak

Snap a proof photo for each daily commitment, the way you'd send a Snapchat
streak — except the streak is your real life, not a chat window.

## What's in here
- `lib/` — full Dart/Flutter source (no `ios/`, `android/` folders yet — see setup below)
- `assets/icon/app_icon.png` — 1024×1024 app icon (aperture ring + glowing streak orb)
- `pubspec.yaml` — dependencies (all official Flutter-team plugins, zero analytics/ads/crash/auth SDKs)

## One-time setup (run these yourself, this container has no Flutter SDK / network)

```bash
# 1. Turn this into a runnable project (creates ios/, android/ folders)
flutter create --org com.yourcompany --platforms=ios .

# 2. Fetch the 4 packages listed in pubspec.yaml
flutter pub get

# 3. Camera permission text (REQUIRED — missing this is an automatic
#    Guideline 2.1 rejection). Open ios/Runner/Info.plist and add:
```

```xml
<key>NSCameraUsageDescription</key>
<string>DoneStreak uses your camera to capture proof photos of your daily commitments. Photos never leave your device.</string>
```

```bash
# 4. Generate all required icon sizes from the one 1024×1024 PNG.
#    flutter_launcher_icons is a build-time code-gen tool (dev dependency
#    only) — it does not ship any runtime code inside your app.
flutter pub add --dev flutter_launcher_icons
```

Add to `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  image_path: "assets/icon/app_icon.png"
  ios: true
  remove_alpha_ios: true
```

```bash
flutter pub run flutter_launcher_icons
flutter build ios
```

## Before handing off to a client (every time)

Run these in order, from the project root, right before zipping/sending the
project or building the final release — this guarantees the client never
gets stale build artifacts, cached debug data, or a broken incremental build:

```bash
flutter clean
flutter pub get
flutter analyze          # fix anything it reports before moving on
flutter test             # if you've added tests
```

Then continue with the platform-specific release build:

```bash
# Android — for Play Store / direct APK handoff
flutter build appbundle --release      # Play Store
flutter build apk --release            # direct-install APK (build/app/outputs/flutter-apk/)

# iOS — only on a Mac (or a Codemagic/cloud-Mac CI), see earlier notes
flutter build ios --release
```

Only the contents of `build/app/outputs/...` (Android) or the Xcode archive
(iOS) — not the whole project folder with its `build/` cache — needs to go
to the client or into App Store Connect / Play Console.

## Rejection checklist before you submit
- [ ] `NSCameraUsageDescription` added (step 3 above) — missing usage strings are the #1 cause of 2.1 rejections.
- [ ] Test on a real device: add a commitment, capture a proof, close and reopen the app, confirm the streak persisted.
- [ ] Confirm the app works fully offline (airplane mode) — there is no network call anywhere in this codebase, so it should.
- [ ] No placeholder/lorem-ipsum text left anywhere.
- [ ] Double-check the App Store name you use isn't already taken (search first).
- [ ] Because this app captures photos, make sure your App Store privacy questionnaire says "no data collected" / "data not linked to you" — the app never uploads anything.
- [ ] Avoid describing the app with language like "streak," "chain," or comparisons to other apps in a way that could look derivative — keep screenshots and description original.

## Why this avoids Guideline 5.6

5.6 (Developer Code of Conduct) is largely triggered by: manipulative
monetization, hidden features that only appear after review, or an app
that's clearly one of many near-identical templated submissions from the
same account. This app has no IAP, no hidden review-only behavior, and no
backend — every build from this template should still be made functionally
distinct (different commitment logic, different visual mechanic) rather than
a reskin, to avoid tripping Apple's pattern detection across multiple app
submissions from the same developer account.
