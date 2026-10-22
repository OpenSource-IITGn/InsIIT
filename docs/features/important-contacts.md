# Important Contacts

**What it does.** A directory of important campus contacts (administration,
security, medical, etc.) with one-tap calling/emailing.

**Where the code lives.**

* `lib/data/importantContactsContainer.dart` - `ImportantContactsContainer`.
* `lib/importantContacts/screens/importantContacts.dart` - the screen.
* `lib/importantContacts/classes/contact.dart`, `contactcard.dart` - model and
  card widget.

**How it gets data.** The contact list is maintained in a Google Sheet and read
through the container's `GSheet`; taps use `url_launcher` to open the dialer or
mail client.

**Route.** `/importantcontacts`.
