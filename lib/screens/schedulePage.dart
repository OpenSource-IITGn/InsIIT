import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  EventModel x = EventModel(
      courseId: "EE333",
      courseName: "Embedded Systems and Microprocessors",
      isCourse: true,
      remarks: 'Bring laptop',
      eventType: 'Lab');
  List<EventModel> eventsList;
  @override
  void initState() {
    super.initState();
    eventsList = [x, x, x, x];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Schedule"),
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
