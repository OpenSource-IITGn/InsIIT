import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class EditEvent extends StatefulWidget {
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  bool loading = false;
  Widget eventCard(EventModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/eventdetail', arguments: {
          'eventModel': model,
        });
      },
      child: Container(
        width: ScreenSize.size.width * 1,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: ScreenSize.size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        stringReturn(model, model.courseName, model.summary),
                        style: TextStyle(
                            color: Colors.black.withAlpha(255),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      Text(
                        stringReturn(model, model.eventType, model.description),
                        style: TextStyle(
                          color: Colors.black.withAlpha(150),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.black,),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                if (model.isCourse) {
                                  removedEvents.add(EventModel(
                                    isCourse: true,
                                    isExam: false,
                                    courseId: model.courseId,
                                    courseName: model.courseName,
                                    eventType: model.eventType,
                                  ));
                                } else if (model.isExam) {
                                  removedEvents.add(EventModel(
                                    isCourse: false,
                                    isExam: true,
                                    courseId: model.courseId,
                                    courseName: model.courseName,
                                    eventType: model.eventType,
                                  ));
                                } else {
                                  removedEvents.add(EventModel(
                                    isCourse: false,
                                    isExam: false,
                                    description: model.description,
                                    summary: model.summary,
                                    location: model.location,
                                    creator: model.creator,
                                    remarks: model.remarks,
                                  ));
                                }
                                Navigator.pop(context);
                                loading = true;
                                setState(() {});
                                var file = await _localFileForRemovedEvents();
                                bool exists = await file.exists();
                                if (exists) {
                                  await file.delete();
                                }
                                await file.create();
                                await file.open();
                                var removedList =
                                    makeRemovedEventsList(removedEvents);
                                await file.writeAsString(
                                    ListToCsvConverter().convert(removedList));
                                print('DATA OF REMOVED EVENT STORED IN FILE');
                                Navigator.popUntil(context, ModalRoute.withName('/menuBarBase'));
                              },
                              child: Text('Yes'),
                            ),
                          ],
                          content: Text(
                              'Do you want to remove this event from your schedule?'),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  String stringReturn(
      EventModel model, String textCourse, String textCalendar) {
    if (model.isCourse || model.isExam) {
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

  List<List<String>> makeRemovedEventsList(List<EventModel> removedEvents) {
    List<List<String>> removedEventsList = [];

    removedEvents.forEach((EventModel model) {
      if (model.isCourse) {
        removedEventsList
            .add(['course', model.courseId, model.courseName, model.eventType]);
      } else if (model.isExam) {
        removedEventsList
            .add(['exam', model.courseId, model.courseName, model.eventType]);
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

  _openGoogleCalendar() async {
//    bool isInstalled =
//        await DeviceApps.isAppInstalled('com.google.android.calendar');
//    if (isInstalled) {
//      DeviceApps.openApp('com.google.android.calendar');
//    } else {
      String url = 'https://calendar.google.com';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    //}
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Edit Schedule',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: (loading)
          ? Center(child: CircularProgressIndicator(),)
          :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: eventsList.map<Widget>((EventModel model) {
              return eventCard(model);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "fab1rs",
            onPressed: () {
              Navigator.pushNamed(context, '/addcourse');
            },
            backgroundColor: primaryColor,
            child: Icon(Icons.more_horiz, color:Colors.white),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "fab2rs",
            onPressed: () {
              _openGoogleCalendar();
            },
            backgroundColor: primaryColor,
            child: Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "fab3rs",
            onPressed: () {
              List<EventModel> _coursesList = [];
              if (eventsList != null) {
                eventsList.forEach((EventModel model) {
                  if (model.isCourse || model.isExam) {
                    _coursesList.add(model);
                  }
                });
              }
              Navigator.pushNamed(context, '/exportIcsFile', arguments: {
                'coursesList': _coursesList,
              });
            },
            backgroundColor: primaryColor,
            child: Icon(Icons.file_download, color:Colors.white),
          ),
        ],
      ),
    );
  }
}
