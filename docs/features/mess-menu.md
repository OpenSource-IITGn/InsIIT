# Mess Menu & Feedback

**What it does.** Shows the day's mess menu (breakfast, lunch, snacks, dinner)
for the whole week, and lets students send quick feedback on individual items.

**Where the code lives.**

* `lib/data/messContainer.dart` - `MessContainer`, the data container.
* `lib/messMenu/screens/messmenu.dart` - the menu screen.
* `lib/messMenu/screens/messfeedback.dart` - the feedback screen.
* `lib/messMenu/classes/weekdaycard.dart`, `base.dart`, `labelDrawer.dart` -
  models and widgets.

**How it gets data.** `MessContainer` owns a `GSheet` bound to a mess
spreadsheet and loads several ranges:

* `MessMenu!A:G` - the weekly menu.
* food-vote data and food-illustration data.

It builds a `List<FoodCard>` (one per weekday, each with its four meals) and
also a `Map` of votes. Values arrive as strings from Sheets and are parsed to
integers in the container.

**Feedback.** The feedback screen lets a student upvote/downvote an item or
leave a detailed review; this is written back to a sheet with
`GSheet.writeData`.

**Related.** `lib/unused/` contains older mess-related widgets that are no
longer routed.
