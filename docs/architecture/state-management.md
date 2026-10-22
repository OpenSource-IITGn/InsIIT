# State, Theming & Navigation

## State management

InsIIT keeps state **global and simple**. There is no `ChangeNotifier`,
`Bloc`, or Riverpod in the codebase; the pattern is:

* A single global `dataContainer` (see
  [Data Layer](data-layer.md)) holds all feature data.
* Screens read from `dataContainer.<feature>.<field>` and call
  `setState`/refresh methods to re-render.
* A `provider` package is listed in `pubspec.yaml`, but the dominant pattern is
  the global singleton.

When you add a feature, follow the existing pattern rather than introducing a
new state-management library - consistency keeps the codebase approachable.

## Theming (light & dark mode)

`lib/themeing/notifier.dart` defines a `ThemeContainer` class with a colour for
every semantic role (background, app bar, headings, upvote/downvote, etc.) and
two instances: `lightTheme` and `darkTheme`. A global `theme` variable points at
the active one.

The choice is persisted with `SharedPreferences` under the key `"dark"`:

```dart
Future getTheme() async { ... }      // load saved preference on startup
void swapTheme(darkOn) { ... }       // switch and persist
```

Screens read colours from `theme.<role>` instead of hard-coding values, so
adding a colour to both themes is all that is needed to support a new UI
element in both modes.

## Navigation

`lib/main.dart` declares a `MaterialApp` with a **named-route table**. There is
no router package; navigation is done with
`Navigator.pushNamed(context, '/routeName')`.

Representative routes:

| Route | Screen |
| --- | --- |
| `/signin` | Sign-in (initial route) |
| `/onboarding` | Onboarding |
| `/menuBarBase` | Home shell (bottom nav) |
| `/messmenu`, `/messfeedback` | Mess menu & feedback |
| `/schedule`, `/eventdetail`, `/editevent`, `/addCourses` | Schedule |
| `/shuttle` | Shuttle bus |
| `/map` | Campus map |
| `/hashtags` | Feed hashtags |
| `/importantcontacts` | Important contacts |
| `/Quicklinks` | Quick links / email |
| `/representativePage` | Student representatives |
| `/covidPage` | COVID-19 information |
| `/developers`, `/misc` | Developers & misc |

**To add a screen:** create it under the right feature folder, import it in
`main.dart`, and add an entry to the `routes` map.
