# Notifications

**What it does.** Delivers push notifications to devices.

**Where the code lives.**

* `lib/notifications/pushNotifications.dart` - notification setup and handlers.
* Firebase Cloud Messaging is configured in `main.dart` and the platform
  projects.

**How it works.** The app registers with Firebase Cloud Messaging and handles
incoming messages. Local, time-based reminders (for example shuttle reminders)
use `flutter_local_notifications` instead.
