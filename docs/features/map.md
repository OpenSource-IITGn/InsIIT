# Campus Map

**What it does.** Displays an interactive map of the IITGN campus.

**Where the code lives.**

* `lib/data/mapContainer.dart` - `MapContainer`.
* `lib/map/screens/googlemap.dart` - the map screen.

**How it gets data.** The map is rendered with `google_maps_flutter` and
location is obtained with the `location` package. Map markers/locations are
loaded through the container (locations are also a Google Sheets-backed dataset
- see `lib/utilities/constants.dart` and the `Locations` constant).

**Route.** `/map`.

**Setup note.** A Google Maps API key must be present in the Android/iOS
platform configuration for the map to render; a blank map usually means the key
is missing.
