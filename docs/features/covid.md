# COVID-19 Information

**What it does.** Displays campus COVID-19 updates and an FAQ.

**Where the code lives.**

* `lib/data/covidContainer.dart` - `CovidContainer`.
* `lib/covid/screens/covidPage.dart` - the screen.
* `lib/covid/classes/covidupdate.dart`, `covidfaq.dart` - models.

**How it gets data.** Updates and FAQs are maintained in Google Sheets, so the
institute can publish new guidance without an app release.

**Route.** `/covidPage`.
