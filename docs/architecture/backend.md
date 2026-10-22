# Backend & APIs

InsIIT is not purely a client app - it talks to several services. Understanding
which service owns which data is the fastest way to understand the codebase.

## 1. Google Sheets (the main content store)

Most of the app's *read* content is served from Google Sheets via the
`GSheet` client (see [Data Layer](data-layer.md)). This is a deliberate choice:
campus staff can edit a spreadsheet and the app reflects it without a release.
Examples include the mess menu, food votes, important contacts, shuttle data,
quick links, representatives, and COVID updates. Some features also *write*
back to sheets (mess feedback, certain bookings).

## 2. Node.js REST backend

`DataContainer.baseUrl` points at a Node.js service:

```
serene-reaches-30469.herokuapp.com
```

This backend (paired with **MongoDB Atlas**) handles the dynamic, user-generated
parts of the app - the news feed and posts, and account-related data - that do
not fit the spreadsheet model.

## 3. Firebase

Firebase provides the account and device services:

* **Authentication** - Google sign-in (`google_sign_in` + `firebase_auth`).
* **Cloud Messaging** - push notifications (`firebase_messaging`).
* **Analytics** and **Crashlytics** - usage and crash reporting.

Configuration lives in `android/app/google-services.json` (committed) and the
iOS equivalent.

## 4. Other external services

* **Google Maps** (`google_maps_flutter`) for the campus map.
* **Google Calendar / Classroom scopes** (`calendar.events.readonly`,
  `classroom.courses.readonly`) for importing events and courses into the
  schedule.
* A quotes API (`quotes.rest`) used on the home screen.

## Summary table

| Concern | Service | Where in code |
| --- | --- | --- |
| Campus content (read/write) | Google Sheets | `lib/utilities/googleSheets.dart`, `lib/data/*Container.dart` |
| Feed & accounts (dynamic) | Node.js + MongoDB Atlas | `DataContainer.baseUrl`, `lib/data/feedContainer.dart` |
| Auth, push, analytics, crash reports | Firebase | `lib/data/authContainer.dart`, `lib/notifications/` |
| Maps | Google Maps | `lib/map/screens/googlemap.dart` |
| Calendar / courses | Google APIs | `lib/schedule/` |
