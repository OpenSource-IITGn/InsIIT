# News Feed

**What it does.** A social-style feed of campus announcements, events and posts,
with hashtags and comments.

**Status.** Beta (per the project README).

**Where the code lives.**

* `lib/data/feedContainer.dart` - `FeedContainer`.
* `lib/feed/screens/feedPage.dart` - the feed.
* `lib/feed/screens/fullPostPage.dart` - a single post with comments.
* `lib/feed/screens/hashtagsPage.dart` - posts filtered by hashtag.
* `lib/feed/classes/` - `postModel.dart`, `commentModel.dart`,
  `hashtagModel.dart`.

**How it gets data.** Unlike the sheet-backed features, the feed is dynamic and
user-generated, so it is served by the **Node.js + MongoDB** backend at
`DataContainer.baseUrl`, not Google Sheets.

**Route.** `/hashtags` (and the feed is reachable from the home shell).
