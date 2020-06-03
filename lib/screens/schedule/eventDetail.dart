import 'package:flutter/cupertino.dart';
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
  String twoDigitTime(String text) {
    if (text.length == 1) {
      String _text = '0' + text;
      return _text;
    } else {
      return text;
    }
  }

  String time (DateTime time) {
    if (time == null) {
      return "Whole Day";
    }
    else {
      return twoDigitTime(time.hour.toString()) + ':' + twoDigitTime(time.minute.toString());
    }
  }

  Widget body (EventModel event) {
    if (event.isCourse) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
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
                'Time: ' + time(event.start) + ' to ' + time(event.end),
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
    } else if (event.isExam) {
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
                'Roll Numbers: ${event.rollNumbers}',
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Time: ' + time(event.start) + ' to ' + time(event.end),
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
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Text(
                'Event: ' + stringReturn(event.summary),
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Invited by: ' + stringReturn(event.creator),
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Description: ' + stringReturn(event.description),
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Time: ' + time(event.start) + ' To ' + time(event.end),
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
            Text(
                'Location: ' + stringReturn(event.location),
                style: TextStyle(
                    color: Colors.black.withAlpha(255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
            ),
            SizedBox(height: 10,),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    eventModelData = ModalRoute.of(context).settings.arguments;
    EventModel event = eventModelData['eventModel'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: body(event),
      ),
    );
  }
}
