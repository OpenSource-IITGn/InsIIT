# Data Layer & Offline Cache

## `DataContainer` - the root of the data layer

`lib/data/dataContainer.dart` defines a single global variable `dataContainer`
holding one `DataContainer` instance. `DataContainer` owns one **container per
feature** and a `baseUrl` for the REST backend:

```dart
var dataContainer;

class DataContainer {
  String baseUrl = "serene-reaches-30469.herokuapp.com";

  FeedContainer feed = FeedContainer();
  MessContainer mess = MessContainer();
  ScheduleContainer schedule = ScheduleContainer();
  ImportantContactsContainer contacts = ImportantContactsContainer();
  ShuttleContainer shuttle = ShuttleContainer();
  RepresentativesContainer representatives = RepresentativesContainer();
  QuickLinksContainer quickLinks = QuickLinksContainer();
  AuthContainer auth = AuthContainer();
  MapContainer map = MapContainer();
  CovidContainer covid = CovidContainer();

  Future<void> initializeCaches() async { ... }   // opens a Hive box per feature
  getOtherData({forceRefresh: false}) { ... }      // refreshes the sheet-backed features
}
```

Screens read data by reaching into this global, e.g. `dataContainer.mess.foodCards`.

## The Google Sheets client: `GSheet`

`lib/utilities/googleSheets.dart` wraps the Sheets v4 API. Each feature creates
its own `GSheet` bound to a specific **spreadsheet ID**, e.g. the mess container:

```dart
GSheet sheet = GSheet('1shyZ4dzs1Txug1E2dsnH15lO5DF7g9oh5Rkuatxa3TY');
```

Key methods:

* `initializeCache()` - opens a Hive box keyed by spreadsheet ID.
* `getData(range, {forceRefresh})` - a `Stream` that yields cached data
  immediately, then fetches from the network and caches it when a refresh is
  due.
* `writeData(data, range)` - appends rows back to a sheet (used for feedback and
  booking submissions).
* `isRefreshRequired()` - returns `true` when the cache is older than one day
  (the `lastAccessed` timestamp is stored alongside the data).

Authentication uses a `ServiceAccountCredentials` object imported from
`lib/credentials/credentials.dart`, which is git-ignored - see
[Installation](../getting-started/installation.md).

## Cache strategy in one paragraph

On first launch there is no cache, so data is fetched online and stored in Hive.
On later launches the cached value is returned instantly, and a background
refresh runs only if more than a day has passed (or if the caller passes
`forceRefresh: true`). This is what lets the app show the mess menu and schedule
with no connectivity.

## Adding a new sheet-backed feature

1. Create `lib/<feature>/classes/` models.
2. Create `lib/data/<feature>Container.dart` with a `GSheet` pointing at your
   spreadsheet ID, plus `initializeCache()` and `getData()`.
3. Register the container in `DataContainer` and add it to `initializeCaches()`
   and `getOtherData()`.
