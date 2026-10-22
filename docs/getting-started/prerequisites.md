# Prerequisites

Before you can build InsIIT you need a working Flutter toolchain and a few
project-specific configuration files.

## Tooling

* **Flutter SDK** - the app declares an SDK constraint of `>=2.3.0 <3.0.0` in
  `pubspec.yaml`, so it is built against a **Flutter 1.x / Dart 2.x** toolchain.
  Newer Flutter releases (which use Dart 3) will **not** resolve these
  dependencies without changes; use an older Flutter channel, or be prepared to
  migrate the dependency set.
* **Dart** (bundled with Flutter).
* **Android Studio** (with the Android SDK) for Android builds, and/or
  **Xcode** (macOS only) for iOS builds.
* A physical device or emulator.
* **Git**.

You can confirm your toolchain with:

```bash
flutter --version
flutter doctor
```

## Configuration you will need to provide

InsIIT talks to several external services, and the secret configuration for
those is deliberately **not** committed to the repository. You will need:

1. **Google service-account credentials** - the app reads public Google Sheets
   through a service account. The credentials object is expected at
   `lib/credentials/credentials.dart` (this path is in `.gitignore`).
2. **Firebase configuration** - `android/app/google-services.json` for Android
   (and the iOS equivalent if you build for iOS). This file *is* committed, so
   a fresh clone should build against the existing Firebase project.
3. **A signing key** - for release Android builds the project expects a keystore
   (`key.jks`). For local development you should switch back to the debug
   signing config (see [Installation](installation.md)).

> Ask a maintainer for access to the shared credentials, or create your own
> Google Cloud service account and Firebase project if you are working on your
> own fork.
