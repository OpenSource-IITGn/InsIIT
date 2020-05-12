import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  List<calendar.Event> todayEvents;
  List<calendar.Event> _events;
  EventModel x = EventModel(
      courseId: "EE333",
      courseName: "Embedded Systems and Microprocessors",
      isCourse: true,
      remarks: 'Bring laptop',
      eventType: 'Lab');
  List<EventModel> eventsList = [];
  @override
  void initState() {
    super.initState();
    _events = listWithoutRepetition(events);
    todayEvents = todayEventsList(_events);
    quickSort(todayEvents, 0, todayEvents.length - 1);
    todayEvents.forEach((calendar.Event event) {
      eventsList.add(EventModel(start: event.start.dateTime, end: event.end.dateTime , isCourse: false, description: event.description, summary: event.summary, location: event.location, creator: event.creator.displayName));
    });
  }

  List listWithoutRepetition (List<calendar.Event> events) {
    List<calendar.Event> withoutRepeat = [];
    events.forEach((calendar.Event event) {
      bool notHave = true;
      withoutRepeat.forEach((calendar.Event _event) {
        if (_event.id == event.id) {
          notHave = false;
        }
      });
      if (notHave) {
        withoutRepeat.add(event);
      }
    });
    return withoutRepeat;
  }

  List todayEventsList (List<calendar.Event> _events) {
    List<calendar.Event> todayEvents = [];
    _events.forEach((calendar.Event _event ) {
      if (_event.start.dateTime != null) {
        DateTime today = DateTime.now();
        DateTime eventStartTime = _event.start.dateTime;
        if (eventStartTime.year == today.year &&
            eventStartTime.month == today.month &&
            eventStartTime.day == today.day) {
          todayEvents.add(_event);
        }
      }
    });
    return todayEvents;
  }

  int partition(List<calendar.Event> list, int low, int high) {
    if (list == null || list.length == 0) return 0;
    DateTime pivot = list[high].start.dateTime;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].start.dateTime.isBefore(pivot) || list[j].start.dateTime.isAtSameMomentAs(pivot)) {
        i++;
        swap(list, i, j);
      }
    }
    swap(list, i+1, high);
    return i+1;
  }

  void swap(List<calendar.Event> list, int i, int j) {
    calendar.Event temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  void quickSort(List<calendar.Event> list, int low, int high) {
    if (low < high) {
      int pi = partition(list, low, high);
      quickSort(list, low, pi-1);
      quickSort(list, pi+1, high);
    }
  }

  Widget body () {
    if (eventsList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Take rest!'),
            SizedBox(height: 8,),
            Text('No Classes or Events to attend Today.'),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColumnBuilder(
            mainAxisSize: MainAxisSize.min,
            itemBuilder: (context, index) {
              return eventsList[index].buildCard();
            },
            itemCount: eventsList.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Schedule"),
      ),
      body: body(),
    );
  }
}
