# Room & Equipment Booking

**What it does.** Integrates campus booking systems:

* **Tinkerers' Lab** - booking of 3D printers and laser cutters.
* **Academic block / rooms** - room booking with available-room lookup and time
  selection.

**Status.** Alpha (in progress - contributions welcome, per the README).

**Where the code lives.**

* `lib/Booking/TLBooking/` - the Tinkerers' Lab flow
  (`firstPage.dart` … `fourthPage.dart`, `TLContactPage.dart`, `tlclass.dart`).
* `lib/Booking/roomBooking/` - the room-booking flow
  (`AvailableRooms.dart`, `Selecttime.dart`, `form3.dart`, `roomservice.dart`,
  `functions.dart`).

**How it gets data.** Available rooms and slots come from Sheets-backed data,
and confirmed bookings are submitted back through the backend / sheets.

**Routes.** The Tinkerers' Lab flow uses `/firstPage` … `/fourthPage`,
`/tlcontacts`; room booking uses `/RoomBooking`, `/availablerooms`,
`/selecttime`, `/bookingform`.
