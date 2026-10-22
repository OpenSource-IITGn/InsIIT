# Project Structure

The repository is a standard Flutter project whose Dart source lives under
`lib/`. On the `dev` branch the code is organised **by feature**, with each
feature owning a `screens/` folder (UI) and, where needed, a `classes/` folder
(data models). Cross-cutting code lives in `data/` and `utilities/`.

```
InsIIT/
├── android/            # Android platform project
├── ios/                # iOS platform project
├── assets/             # Images, fonts (OpenSans), map assets
├── lib/                # All Dart source (see below)
├── test/               # Widget tests
├── readmeImages/       # Screenshots used by the README
├── PlayStore Images/   # Store listing artwork
├── stuff/              # Launcher icon source
├── pubspec.yaml        # Dependencies and app metadata
├── README.md           # Project overview
├── SUMMARY.md          # GitBook table of contents
└── LICENSE             # GNU GPL-3.0
```

## Inside `lib/`

```
lib/
├── main.dart                     # Entry point, app + route table
├── data/                         # The data layer (one container per feature)
│   ├── dataContainer.dart        # Aggregates every feature container
│   ├── authContainer.dart
│   ├── messContainer.dart
│   ├── scheduleContainer.dart
│   ├── feedContainer.dart
│   ├── mapContainer.dart
│   ├── covidContainer.dart
│   ├── importantContactsContainer.dart
│   ├── quickLinksContainer.dart
│   ├── representativesContainer.dart
│   └── shuttleContainer.dart
├── utilities/                    # Shared helpers
│   ├── googleSheets.dart         # Google Sheets client + Hive caching
│   ├── constants.dart            # Screen size, shared constants
│   ├── bottomNavBar.dart
│   ├── carouselSlider.dart
│   ├── columnBuilder.dart
│   ├── dot_indicator.dart
│   ├── globalFunctions.dart
│   ├── measureSize.dart
│   └── slider.dart
├── globalClasses/
│   └── user.dart                 # The signed-in user model
├── themeing/
│   └── notifier.dart             # Light/dark ThemeContainer definitions
├── mainScreens/                  # Shell screens
│   ├── signIn.dart
│   ├── onboarding.dart
│   ├── homePage.dart
│   ├── firsthomepage.dart
│   ├── loading.dart
│   └── miscPage.dart
├── messMenu/
│   ├── screens/                  # messmenu.dart, messfeedback.dart
│   └── classes/                  # weekdaycard.dart, base.dart, labelDrawer.dart
├── schedule/
│   ├── screens/                  # schedulePage, addCourse, editEvents, ...
│   └── classes/                  # courseClass, eventClass, examClass, ...
├── shuttle/
│   ├── screens/shuttle.dart
│   └── classes/                  # buses.dart, Constants.dart
├── map/screens/googlemap.dart
├── feed/
│   ├── screens/                  # feedPage, fullPostPage, hashtagsPage
│   └── classes/                  # postModel, commentModel, hashtagModel
├── Booking/
│   ├── TLBooking/                # Tinkerers' Lab booking flow
│   └── roomBooking/              # Room booking flow
├── importantContacts/
│   ├── screens/importantContacts.dart
│   └── classes/                  # contact.dart, contactcard.dart
├── quickLinks/screens/email.dart
├── covid/
│   ├── screens/covidPage.dart
│   └── classes/                  # covidfaq.dart, covidupdate.dart
├── representativePage/
│   ├── screens/representativePage.dart
│   └── classes/representatives.dart
├── notifications/pushNotifications.dart
├── developers/screens/developers.dart
└── unused/                       # Parked/legacy screens, not routed
```

## The convention

Every feature follows the same shape:

1. A **container** in `lib/data/` that fetches and holds the feature's data.
2. **Model classes** in the feature's `classes/` folder.
3. **Screens** in the feature's `screens/` folder.
4. A **route** registered in the `routes` map in `main.dart`.

Once you know this pattern, finding the code for any feature is mechanical:
find the container in `data/`, then open its `screens/` folder.
