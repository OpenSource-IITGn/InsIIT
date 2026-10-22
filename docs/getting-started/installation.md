# Installation & Configuration

## 1. Clone the repository

```bash
git clone https://github.com/OpenSource-IITGn/InsIIT.git
cd InsIIT
git checkout dev        # the default and active branch
```

## 2. Install dependencies

```bash
flutter pub get
```

## 3. Add the Google service-account credentials

The Google Sheets client expects a `credentials` object in
`lib/credentials/credentials.dart`. That file is **git-ignored** and is not
shipped with the repository.

Create the folder and file:

```bash
mkdir -p lib/credentials
```

Then add a file `lib/credentials/credentials.dart` that exports a
`ServiceAccountCredentials` value named `credentials`, for example:

```dart
import 'package:googleapis_auth/auth_io.dart' as auth;

final auth.ServiceAccountCredentials credentials =
    auth.ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "<your-project-id>",
  "private_key_id": "<key-id>",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "<service-account>@<project>.iam.gserviceaccount.com",
  "client_id": "<client-id>",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token"
}
''');
```

The service account must have read access to the Google Sheets the app uses.
Get the JSON key from the Google Cloud console (IAM & Admin → Service Accounts
→ Keys), and share the relevant spreadsheets with the service-account email.

## 4. Firebase

`android/app/google-services.json` is committed, so Android builds normally
work without extra steps. If you point the app at your own Firebase project,
replace that file and make sure Authentication (Google sign-in) and Cloud
Messaging are enabled in your Firebase console.

## 5. Android signing (release builds)

`readme.txt` in the repository notes that the keystore password is `instiapp`
and that release builds use `key.jks`. For **local development** you should
build in debug mode, or follow the comments in `android/app/build.gradle` to
switch back to the debug signing configuration. Never commit new secrets.

## 6. Verify the setup

```bash
flutter doctor      # resolve any red items
flutter analyze     # static analysis
```

Then continue to [Running & Building](running.md).
