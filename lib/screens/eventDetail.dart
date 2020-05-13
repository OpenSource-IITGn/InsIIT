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
      return Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Text(
            'ID: ${event.courseId}',
          ),
          SizedBox(height: 10,),
          Text(
            'Course: ${event.courseName}',
          ),
          SizedBox(height: 10,),
          Text('ClassRoom: ${event.location}'),
          SizedBox(height: 10,),
          Text('Time: ${event.start} to ${event.end}'),
          SizedBox(height: 10,),
          Text('${event.eventType}'),
          SizedBox(height: 10,),
          Text('${event.remarks}'),
        ],
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
