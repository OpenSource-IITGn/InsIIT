import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';

class EventDetail extends StatefulWidget {
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  Map eventModelData = {};

  String stringReturn(String text) {
    if (text == null) {
      return 'None';
    } else {
      return text;
    }
  }

  String time (DateTime time) {
    if (time == null) {
      return "Whole Day";
    }
    else {
      return "${time.hour}:${time.minute}";
    }
  }

  Widget body (EventModel event) {
    if (event.isCourse) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Text(
                'ID: ${event.courseId}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Course: ${event.courseName}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'ClassRoom: ${event.location}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Time: ${event.start.hour}:${event.start.minute} to ${event.end.hour}:${event.end.minute}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Type: ${event.eventType}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Remarks: ${event.remarks}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                'Instructors: ',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: event.instructors.map<Widget>((String instructor) {
                return Text(
                    instructor,
                    style: TextStyle(
                        color: Colors.black.withAlpha(255),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)
                );
              }).toList(),
            ),
            SizedBox(height: 10,),
            Text(
                'Credits: ${event.credits}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Pre-requisite: ${event.preRequisite}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Text('Event: ' + stringReturn(event.summary)),
          SizedBox(height: 10,),
          Text('Invited by: ' + stringReturn(event.creator)),
          SizedBox(height: 10,),
          Text('Description: ' + stringReturn(event.description)),
          SizedBox(height: 10,),
          Text('Time: ' + time(event.start) + ' To ' + time(event.end)),
          SizedBox(height: 10,),
          Text('Location: ' + stringReturn(event.location)),
          SizedBox(height: 10,),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    eventModelData = ModalRoute.of(context).settings.arguments;
    EventModel event = eventModelData['eventModel'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: body(event),
      ),
    );
  }
}
