# Architecture Overview

InsIIT is a Flutter app built around a **single global data layer** and a
**named-route navigation table**. There is no heavy architectural framework:
the goal is a small, approachable codebase that students can contribute to.

## The layers

```
┌──────────────────────────────────────────────────────────────┐
│  UI (lib/<feature>/screens/**, lib/mainScreens/**)           │
│  Widgets that render data and handle taps                    │
└───────────────▲──────────────────────────────┬───────────────┘
                │ read                          │ write / refresh
┌───────────────┴──────────────────────────────▼───────────────┐
│  Data containers (lib/data/**)                                │
│  One container per feature, aggregated by DataContainer       │
└───────────────▲──────────────────────────────┬───────────────┘
                │                               │
┌───────────────┴───────────────┐  ┌────────────▼──────────────┐
│  Google Sheets (via GSheet)   │  │  REST backend (Node.js)   │
│  + Hive on-device cache       │  │  + Firebase services      │
└───────────────────────────────┘  └───────────────────────────┘
```

## Startup sequence

1. `main()` calls `WidgetsFlutterBinding.ensureInitialized()`.
2. It constructs the global `dataContainer` (`DataContainer()`).
3. It initialises **Hive** in the app documents directory.
4. `dataContainer.initializeCaches()` opens a Hive box for every feature so the
   app can render cached data instantly and offline.
5. `runApp(MyApp())` starts the widget tree.

## Why it is built this way

* **Google Sheets as a content store.** Most campus content (mess menu,
  contacts, shuttle timings, quick links, COVID updates) is maintained in
  spreadsheets, which non-technical staff can edit without a deployment. The
  app reads those sheets through a service account.
* **Offline-first.** Because content changes rarely, every sheet read is cached
  locally in Hive and served from cache until it is refreshed.
* **One container per feature.** Keeps features independent and makes the code
  navigable - the topic of this documentation.

Continue with:

* [Data Layer & Offline Cache](data-layer.md)
* [State, Theming & Navigation](state-management.md)
* [Backend & APIs](backend.md)
