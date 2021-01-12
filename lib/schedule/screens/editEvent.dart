import 'dart:io';
import 'package:csv/csv.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/schedule/classes/courseClass.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:instiapp/schedule/classes/searchDelegate.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/data/dataContainer.dart';

class EditEvent extends StatefulWidget {
  @override
  _EditEventState createState() => _EditEventState();
}

List<CourseModel> notAddedCourses = [];
Map<CourseModel, bool> add = {};
bool loadingAddCourseData = false;

class _EditEventState extends State<EditEvent> {
  bool updateUserAddedCourses = false;
  bool loading = false;
  var thisTheme = theme;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataContainer.schedule.makeAllEventsList();
    return Scaffold(
      backgroundColor: thisTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: thisTheme.appBarColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: thisTheme.iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Schedule',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: thisTheme.textHeadingColor)),
      ),
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (dataContainer.schedule.allEvents.length == 0)
              ? Center(
                  child: Text("No events have been added yet!",
                      style: TextStyle(color: thisTheme.textHeadingColor)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      Course course = dataContainer.scheduleNew
                          .enrolledCourses[DateTime.now().weekday][index];
                      String startTime =
                          formatDate(course.startTime, [HH, ':', nn]);
                      String endTime =
                          formatDate(course.endTime, [HH, ':', nn]);
                      return Card(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.name,
                                  style: TextStyle(
                                      color: theme.textHeadingColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${course.code} | ${startTime} - ${endTime}",
                                  style: TextStyle(
                                    color: theme.textSubheadingColor,
                                  ),
                                ),
                                Text(
                                  course.getCourseType(),
                                  style: TextStyle(
                                    color: theme.textSubheadingColor,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.delete)
                          ],
                        ),
                      ));
                    },
                    itemCount: dataContainer.scheduleNew.enrolledCourses.length,
                  )),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: thisTheme.floatingColor,
            heroTag: "fab1rs",
            onPressed: () {
              Navigator.pushNamed(context, '/addCourses').then((value) {
                // storeCoursesOffline();
              });
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: thisTheme.floatingColor,
            heroTag: "fab2rs",
            onPressed: () {
              // _openGoogleCalendar();
            },
            // backgroundColor: primaryColor,
            child: Icon(Icons.calendar_today, color: Colors.white),
          ),
//          SizedBox(height: 16),
//          FloatingActionButton(
//            heroTag: "fab3rs",
//            onPressed: () {
//              List<EventModel> _coursesList = [];
//              if (eventsList != null &&
//                  eventsList[DateTime.now().weekday - 1] != null) {
//                eventsList[DateTime.now().weekday - 1]
//                    .forEach((EventModel model) {
//                  if (model.isCourse || model.isExam) {
//                    _coursesList.add(model);
//                  }
//                });
//              }
//              Navigator.pushNamed(context, '/exportIcsFile', arguments: {
//                'coursesList': _coursesList,
//              });
//            },
//            backgroundColor: primaryColor,
//            child: Icon(Icons.file_download, color: Colors.white),
//          ),
        ],
      ),
    );
  }
}
