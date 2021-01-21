import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/schedule/classes/courseClass.dart';
import 'package:instiapp/schedule/classes/examClass.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
//import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class EditEvent extends StatefulWidget {
  @override
  _EditEventState createState() => _EditEventState();
}

List<CourseModel> notAddedCourses = [];
Map<CourseModel, bool> add = {};
bool loadingAddCourseData = false;

class _EditEventState extends State<EditEvent>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  var thisTheme = theme;
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    dataContainer.schedule.getAllEnrolledCourses();
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
        bottom: TabBar(
          controller: controller,
          unselectedLabelColor: theme.textHeadingColor.withOpacity(0.3),
          indicatorColor: theme.indicatorColor,
          labelColor: theme.textHeadingColor,
          tabs: [
            Tab(
                child: Text("Courses",
                    style: TextStyle(color: theme.textHeadingColor))),
            Tab(
                child: Text("Exams",
                    style: TextStyle(color: theme.textHeadingColor))),
            Tab(
                child: Text("Events",
                    style: TextStyle(color: theme.textHeadingColor))),
          ],
        ),
        title: Text('Edit Schedule',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: thisTheme.textHeadingColor)),
      ),
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: theme.iconColor,
              ),
            )
          : TabBarView(controller: controller, children: [
              editCourseSchedule(() {
                setState(() {});
              }),
              editExamSchedule(() {
                setState(() {});
              }),
              editEventSchedule(() {
                setState(() {});
              }),
            ]),
      floatingActionButton: (controller.index == 0)
          ? FloatingActionButton(
              backgroundColor: thisTheme.floatingColor,
              tooltip: "Add course",
              onPressed: () {
                if (controller.index == 0) {
                  Navigator.pushNamed(context, '/addCourses').then((value) {
                    setState(() {});
                  });
                } else if (controller.index == 1) {
                  // add exam!
                } else {
                  launch("https://calendar.google.com");
                }
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : Container(),
    );
  }
}

Widget editCourseSchedule(Function setState) {
  return (dataContainer.schedule.allEnrolledSlots.length == 0)
      ? Center(
          child: Text("You have not enrolled in any course yet!",
              style: TextStyle(color: theme.textHeadingColor)))
      : Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              Course course = dataContainer.schedule.allEnrolledSlots[index][0];
              String startTime = formatDate(course.startTime, [HH, ':', nn]);
              String endTime = formatDate(course.endTime, [HH, ':', nn]);
              return Card(
                  color: course.color,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: ScreenSize.size.width * 0.5,
                          child: Column(
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
                                "${course.code.substring(0, 2)}${course.code.substring(2)} | ${weekDay[course.startTime.weekday].substring(0, 3)} | $startTime - $endTime",
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
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: theme.iconColor),
                              onPressed: () {
                                course.navigateToDetail(context).then((val) {
                                  dataContainer.schedule.storeAllData();
                                  setState();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: theme.iconColor),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () async {
                                          dataContainer.schedule.unEnrollCourse(
                                              dataContainer.schedule
                                                  .allEnrolledSlots[index][2],
                                              dataContainer.schedule
                                                  .allEnrolledSlots[index][1],
                                              false);
                                          dataContainer.schedule
                                              .getAllEnrolledCourses();
                                          Navigator.pop(context);
                                          setState();
                                        },
                                        child: Text('Remove only this slot'),
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          dataContainer.schedule.unEnrollCourse(
                                              dataContainer.schedule
                                                  .allEnrolledSlots[index][2],
                                              dataContainer.schedule
                                                  .allEnrolledSlots[index][1],
                                              true);
                                          dataContainer.schedule
                                              .getAllEnrolledCourses();
                                          Navigator.pop(context);
                                          setState();
                                        },
                                        child: Text(
                                            'Unenroll from ${course.code}'),
                                      )
                                    ],
                                    content: Text('Select one option'),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ));
            },
            itemCount: dataContainer.schedule.allEnrolledSlots.length,
          ));
}

Widget editEventSchedule(Function setState) {
  return (dataContainer.schedule.allEvents.length == 0)
      ? Center(
          child: Text("Not going to any event yet :/",
              style: TextStyle(color: theme.textHeadingColor)))
      : Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              Course course = dataContainer.schedule.allEnrolledSlots[index][0];
              String startTime = formatDate(course.startTime, [HH, ':', nn]);
              String endTime = formatDate(course.endTime, [HH, ':', nn]);
              return Card(
                  color: course.color,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenSize.size.width * 0.7,
                              child: Text(
                                course.name,
                                style: TextStyle(
                                    color: theme.textHeadingColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "${course.code} | ${startTime} - ${endTime} | ${weekDay[course.startTime.weekday]}",
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
                        IconButton(
                          icon: Icon(Icons.delete, color: theme.iconColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () async {
                                      dataContainer.schedule.unEnrollCourse(
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][2],
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][1],
                                          false);
                                      dataContainer.schedule
                                          .getAllEnrolledCourses();
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text('Remove only this slot'),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      dataContainer.schedule.unEnrollCourse(
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][2],
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][1],
                                          true);
                                      dataContainer.schedule
                                          .getAllEnrolledCourses();
                                      Navigator.pop(context);
                                      setState();
                                    },
                                    child: Text('Unenroll from ${course.code}'),
                                  )
                                ],
                                content: Text('Select one option'),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ));
            },
            itemCount: dataContainer.schedule.allEnrolledSlots.length,
          ));
}

Widget editExamSchedule(Function setState) {
  return (dataContainer.schedule.allExams.length == 0)
      ? Center(
          child: Text("No exams as of now! Enjoyyyy!!",
              style: TextStyle(color: theme.textHeadingColor)))
      : Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              Exam course = dataContainer.schedule.allExams[index][0];
              String startTime = formatDate(course.startTime, [HH, ':', nn]);
              String endTime = formatDate(course.endTime, [HH, ':', nn]);
              String date =
                  formatDate(course.startTime, [d, ' / ', m, ' (', D, ')']);
              return Card(
                  color: theme.cardBgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenSize.size.width * 0.7,
                              child: Text(
                                course.name,
                                style: TextStyle(
                                    color: theme.textHeadingColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "${course.code} | ${startTime} - ${endTime} | ${date}",
                              style: TextStyle(
                                color: theme.textSubheadingColor,
                              ),
                            ),
                            Text(
                              "Exam",
                              style: TextStyle(
                                color: theme.textSubheadingColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: theme.iconColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () async {
                                      dataContainer.schedule.unEnrollCourse(
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][2],
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][1],
                                          false);
                                      dataContainer.schedule
                                          .getAllEnrolledCourses();
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text('Remove only this slot'),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      dataContainer.schedule.unEnrollCourse(
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][2],
                                          dataContainer.schedule
                                              .allEnrolledSlots[index][1],
                                          true);
                                      dataContainer.schedule
                                          .getAllEnrolledCourses();
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text('Unenroll from ${course.code}'),
                                  )
                                ],
                                content: Text('Select one option'),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ));
            },
            itemCount: dataContainer.schedule.allExams.length,
          ));
}
