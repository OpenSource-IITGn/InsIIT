import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/schedulePage.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:path_provider/path_provider.dart';

class EditEvent extends StatefulWidget {
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  Widget eventCard (EventModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 8,),
            Text(
            stringReturn(model, model.courseName, model.summary),
              style: TextStyle(
                  color: Colors.black.withAlpha(255),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            SizedBox(height: 8,),
            Text(
              stringReturn(model, model.eventType, model.description),
              style: TextStyle(
                  color: Colors.black.withAlpha(255),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            SizedBox(height: 8,),
            FlatButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    content: Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Do you want to remove this event from your schedule?'),
                          SizedBox(height: 5,),
                          FlatButton(
                            onPressed: () async {
                              if (model.isCourse) {
                                removedEvents.add(EventModel(
                                  isCourse: true,
                                  courseId: model.courseId,
                                  courseName: model.courseName,
                                  eventType: model.eventType,
                                ));
                              } else {
                                removedEvents.add(EventModel(
                                  isCourse: false,
                                  description: model.description,
                                  summary: model.summary,
                                  location: model.location,
                                  creator: model.creator,
                                  remarks: model.remarks,
                                ));
                              }
                              Navigator.pushReplacementNamed(context, '/schedule');
                              var file = await _localFileForRemovedEvents();
                              bool exists = await file.exists();
                              if (exists) {
                                await file.delete();
                              }
                              await file.create();
                              await file.open();
                              var removedList = makeRemovedEventsList(removedEvents);
                              await file.writeAsString(ListToCsvConverter().convert(removedList));
                              print('DATA OF REMOVED EVENT STORED IN FILE');
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.delete,
              ),
              label: Text('Remove this event'),
            ),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }

  String stringReturn(EventModel model, String textCourse, String textCalendar) {
    if (model.isCourse) {
      return textCourse;
    } else {
      if (textCalendar == null) {
        return 'None';
      } else if (textCalendar.length < 100) {
        return textCalendar;
      } else {
        return textCalendar.substring(0, 99);
      }
    }
  }

  List<List<String>> makeRemovedEventsList (List<EventModel> removedEvents) {
    List<List<String>> removedEventsList = [];

    removedEvents.forEach((EventModel model) {
      if (model.isCourse) {
        removedEventsList.add([
          'course',
          model.courseId,
          model.courseName,
          model.eventType
        ]);
      } else {
        removedEventsList.add([
          'calendar',
          model.description,
          model.summary,
          model.location,
          model.creator,
          model.remarks
        ]);
      }
    });

    return removedEventsList;
  }

  Future<File> _localFileForRemovedEvents() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = tempPath + 'removedCourses' + '.csv';
    return File(filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Events'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: eventsList.map<Widget>((EventModel model) {
              return eventCard(model);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
