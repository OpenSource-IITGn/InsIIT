# FAQ

**Which branch should I work on?**
`dev`. It is the default branch and where active development happens. `master`
is behind it.

**The app won't build - dependency errors.**
The pinned dependencies target Dart 2.x (`sdk: ">=2.3.0 <3.0.0"`). Use a
Flutter 1.x toolchain, or migrate the dependency set when moving to a newer
Flutter.

**Data shows up blank or stale.**
Google Sheets data is cached in Hive. Force a refresh from the UI, or clear app
data. Also confirm `lib/credentials/credentials.dart` exists and the service
account can read the sheets.

**Where do I put a new feature?**
Create `lib/<feature>/screens/` and `lib/<feature>/classes/`, add a container in
`lib/data/`, register it in `DataContainer`, and add a route in `main.dart`. See
[Project Structure](project-structure.md).

**Is the backend open source?**
The app is GPL-3.0. The REST backend (Node.js + MongoDB) is referenced by
`DataContainer.baseUrl`; ask maintainers for its repository if you need to
change backend behaviour.

**I found a security problem.**
Do not open a public issue. Contact the maintainers privately (via the Discord
or the repository owners). See the security note in the detailed report that
accompanies this documentation.
