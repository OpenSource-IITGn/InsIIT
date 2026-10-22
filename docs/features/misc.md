# Misc & Developers

**What it does.** Houses smaller screens that do not belong to a full feature.

**Where the code lives.**

* `lib/mainScreens/miscPage.dart` - the misc screen (route `/misc`).
* `lib/developers/screens/developers.dart` - the in-app developers/credits
  screen (route `/developers`).
* `lib/unused/` - parked screens (`addtext.dart`, `announcements.dart`,
  `articles.dart`, `complains.dart`, `menuBarBase.dart`, `textcard.dart`) that
  are **not** routed. They are kept for reference; treat them as legacy.

**Note.** If you revive a screen from `lib/unused/`, move it into the relevant
feature folder, update its imports, and register a route in `main.dart`.
