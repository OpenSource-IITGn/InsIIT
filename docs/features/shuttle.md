# Shuttle / Bus

**What it does.** Shows campus shuttle bus routes and lets a student set a
reminder for the bus they want to catch.

**Where the code lives.**

* `lib/data/shuttleContainer.dart` - `ShuttleContainer`.
* `lib/shuttle/screens/shuttle.dart` - the shuttle screen.
* `lib/shuttle/classes/buses.dart` - the bus model.
* `lib/shuttle/classes/Constants.dart` - shuttle constants.

**How it gets data.** Timings and route information come from a Google Sheet,
loaded through the container's `GSheet`. Reminders are scheduled locally with
`flutter_local_notifications`.

**Route.** `/shuttle`.

**Planned.** The README lists *live GPS tracking of buses* as an in-progress
(alpha) item under the IR&P council - a good place for a new contributor to
start.
