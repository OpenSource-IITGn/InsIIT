# Running & Building

## Run in debug mode

With a device connected or an emulator running:

```bash
flutter devices          # list available devices
flutter run              # build and launch on the selected device
```

The app opens on the sign-in screen (`/signin`) - see
[Navigation](architecture/state-management.md) for the route table.

## Build a release APK

```bash
flutter build apk --release
```

The output is written to `build/app/outputs/flutter-apk/`.

## Build for iOS

```bash
flutter build ios --release
```

An iOS build requires macOS and Xcode, plus a valid provisioning profile.

## Static analysis and tests

```bash
flutter analyze
flutter test
```

## Common issues

* **Dependency resolution fails** - the pinned dependencies target Dart 2.x.
  Run with a Flutter 1.x toolchain, or update `pubspec.yaml` when migrating.
* **Google Sheets returns empty data** - check that
  `lib/credentials/credentials.dart` exists and that the service account has
  access to the relevant spreadsheets.
* **Map is blank** - `google_maps_flutter` requires an API key configured in the
  Android/iOS platform manifests.
* **Stale content** - the app caches Google Sheets data in Hive for offline use.
  Force a refresh from the UI, or clear app data, to pull the latest values.
