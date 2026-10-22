# Class Schedule & Calendar

**What it does.** Shows a student's daily and weekly schedule. Courses are
loaded automatically for the current semester with the option to enrol/unenrol;
exams appear automatically during midsem/endsem; calendar events are shown
alongside classes.

**Where the code lives.**

* `lib/data/scheduleContainer.dart` - `ScheduleContainer`.
* `lib/schedule/screens/schedulePage.dart` - main schedule view.
* `lib/schedule/screens/addCourse.dart` - add a course.
* `lib/schedule/screens/editEvents.dart`, `eventDetail.dart` - edit/view events.
* `lib/schedule/screens/exportIcsFile.dart` - export to an `.ics` calendar file.
* `lib/schedule/classes/` - `courseClass.dart`, `eventClass.dart`,
  `examClass.dart`, `scheduleModel.dart`, `searchDelegate.dart`.

**How it gets data.** The container reads course and event data (largely from
Google Sheets) and imports calendar/classroom data through the Google Calendar
and Classroom scopes declared in the OAuth scopes. The exported `.ics` file lets
a student subscribe from any calendar app.

**Routes.** `/schedule`, `/eventdetail`, `/editevent`, `/addCourses`.
