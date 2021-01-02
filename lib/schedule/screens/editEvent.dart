import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
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

List<MyCourse> notAddedCourses = [];
Map<MyCourse, bool> add = {};
bool loadingAddCourseData = false;

class _EditEventState extends State<EditEvent> {
  bool updateUserAddedCourses = false;
  bool loading = false;
  var thisTheme = theme;
  @override
  void initState() {
    super.initState();
    notAddedCourses = makeNotAddedCoursesList(
        dataContainer.schedule.userAddedCourses,
        dataContainer.schedule.allCourses);
    add = makeAddMap(notAddedCourses);
  }

  List<MyCourse> makeNotAddedCoursesList(
      List<MyCourse> myCourses, List<MyCourse> allCourses) {
    List<MyCourse> remainingCourses = [];

    allCourses.forEach((MyCourse course) {
      bool contain = true;
      if (dataContainer.schedule.userAddedCourses != null) {
        myCourses.forEach((MyCourse addedCourse) {
          if (addedCourse.courseCode == course.courseCode ||
              addedCourse.courseName == course.courseName) {
            contain = false;
          }
        });
      }

      if (contain) {
        remainingCourses.add(course);
      }
    });

    return remainingCourses;
  }

  Map<MyCourse, bool> makeAddMap(List<MyCourse> remainingCourses) {
    Map<MyCourse, bool> _add = {};
    remainingCourses.forEach((MyCourse course) {
      _add.putIfAbsent(course, () => false);
    });

    return _add;
  }

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
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      Text(
                        stringReturn(model, model.eventType, model.description),
                        style: TextStyle(
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
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                if (model.isCourse) {
                                  updateUserAddedCourses = true;
                                } else if (model.isExam) {
                                  dataContainer.schedule.removedEvents
                                      .add(EventModel(
                                    isCourse: false,
                                    isExam: true,
                                    courseId: model.courseId,
                                    courseName: model.courseName,
                                    eventType: model.eventType,
                                  ));
                                } else {
                                  dataContainer.schedule.removedEvents
                                      .add(EventModel(
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
                                if (updateUserAddedCourses) {
                                  var file2 =
                                      await localFile('userAddedCourses');
                                  bool exists2 = await file2.exists();
                                  if (exists2) {
                                    await file2.delete();
                                  }
                                  await file2.create();
                                  await file2.open();
                                  var userAddedCoursesList =
                                      makeUpdatedUserAddedCoursesList(model);
                                  await file2.writeAsString(ListToCsvConverter()
                                      .convert(userAddedCoursesList));
                                  // print('DATA OF ADDED EVENT STORED IN FILE');
                                }
                                var file = await localFile('removedCourses');
                                bool exists = await file.exists();
                                if (exists) {
                                  await file.delete();
                                }
                                await file.create();
                                await file.open();
                                var removedList = makeRemovedEventsList(
                                    dataContainer.schedule.removedEvents);
                                await file.writeAsString(
                                    ListToCsvConverter().convert(removedList));
                                // print('DATA OF REMOVED EVENT STORED IN FILE');
                                Navigator.popAndPushNamed(
                                    context, '/menuBarBase');
                                //Navigator.popUntil(context, ModalRoute.withName('/menuBarBase'));
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

  List<List<String>> makeUpdatedUserAddedCoursesList(EventModel _course) {
    List<List<String>> updatedList = [];

    if (dataContainer.schedule.userAddedCourses != null) {
      dataContainer.schedule.userAddedCourses.forEach((MyCourse course) {
        if (course.courseCode != _course.courseId ||
            course.courseName != _course.courseName) {
          updatedList.add([
            course.courseCode,
            course.courseName,
            course.noOfLectures.toString(),
            course.noOfTutorials.toString(),
            course.credits.toString(),
            course.instructors.join(','),
            course.preRequisite,
            course.lectureCourse.join(',') + '(' + course.lectureLocation + ')',
            course.tutorialCourse.join(',') +
                '(' +
                course.tutorialLocation +
                ')',
            course.labCourse.join(',') + '(' + course.labLocation + ')',
            course.remarks,
            course.courseBooks,
            course.links.join(',')
          ]);
        }
      });
    }

    return updatedList;
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
//    }
  }

  @override
  Widget build(BuildContext context) {
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
          : (dataContainer
                      .schedule.eventsList[DateTime.now().weekday - 1].length ==
                  0)
              ? Center(
                  child: Text("No events have been added yet!",
                      style: TextStyle(color: thisTheme.textHeadingColor)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: dataContainer
                          .schedule.eventsList[DateTime.now().weekday - 1]
                          .map<Widget>((EventModel model) {
                        return eventCard(model);
                      }).toList(),
                    ),
                  ),
                ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: thisTheme.floatingColor,
            heroTag: "fab1rs",
            onPressed: () {
              //Navigator.popAndPushNamed(context, '/addcourse');
              showSearch(
                context: context,
                delegate: CustomSearch(),
              );
            },
            // backgroundColor: primaryColor,
            child: Icon(Icons.add, color: thisTheme.iconColor),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: thisTheme.floatingColor,
            heroTag: "fab2rs",
            onPressed: () {
              _openGoogleCalendar();
            },
            // backgroundColor: primaryColor,
            child: Icon(Icons.calendar_today, color: thisTheme.iconColor),
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

class CustomSearch extends SearchDelegate {
  var thisTheme = lightTheme;
  addCourses(Map<MyCourse, bool> add, BuildContext context) {
    loadingAddCourseData = true;
    query = "gfufievkldnvodjsjvkdsnvklnviwehlekwdmcnewklvnlehvldkncken";
    add.forEach((MyCourse course, bool addCourse) {
      if (addCourse) {
        addIfNotPresent(course);
      }
    });

    saveFileInCache(context);
  }

  addIfNotPresent(MyCourse course) {
    bool add = true;
    if (dataContainer.schedule.userAddedCourses != null) {
      dataContainer.schedule.userAddedCourses.forEach((MyCourse _course) {
        if (course.courseName == _course.courseName ||
            course.courseCode == _course.courseCode) {
          add = false;
        }
      });
    } else {
      dataContainer.schedule.userAddedCourses = [];
    }

    if (add) {
      dataContainer.schedule.userAddedCourses.add(course);
    }
  }

  saveFileInCache(BuildContext context) async {
    var file = await _localFileForUserAddedCourses();
    bool exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    await file.create();
    await file.open();
    var userAddedCoursesList =
        makeUserAddedCoursesList(dataContainer.schedule.userAddedCourses);
    await file
        .writeAsString(ListToCsvConverter().convert(userAddedCoursesList));
    print('DATA OF ADDED EVENT STORED IN FILE');

    query = '';
    loadingAddCourseData = false;
    Navigator.popAndPushNamed(context, '/menuBarBase');
    //Navigator.popUntil(context, ModalRoute.withName('/menuBarBase'));
  }

  List<List<String>> makeUserAddedCoursesList(List<MyCourse> userAddedCourses) {
    List<List<String>> userAddedCoursesList = [];

    userAddedCourses.forEach((MyCourse course) {
      userAddedCoursesList.add([
        course.courseCode,
        course.courseName,
        course.noOfLectures.toString(),
        course.noOfTutorials.toString(),
        course.credits.toString(),
        course.instructors.join(','),
        course.preRequisite,
        course.lectureCourse.join(',') + '(' + course.lectureLocation + ')',
        course.tutorialCourse.join(',') + '(' + course.tutorialLocation + ')',
        course.labCourse.join(',') + '(' + course.labLocation + ')',
        course.remarks,
        course.courseBooks,
        course.links.join(',')
      ]);
    });

    return userAddedCoursesList;
  }

  Future<File> _localFileForUserAddedCourses() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = tempPath + 'userAddedCourses' + '.csv';
    return File(filename);
  }

  Widget courseCard(MyCourse course, Map<MyCourse, bool> add) {
    return GestureDetector(
      onTap: () {
        if (add[course]) {
          add[course] = false;
        } else {
          add[course] = true;
        }

        String temp = query;
        query = query + 'a';
        query = temp;
      },
      child: Container(
        width: ScreenSize.size.width * 1,
        child: Card(
          color: (add[course]) ? thisTheme.cardAccent : thisTheme.cardBgColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(course.courseCode,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: thisTheme.textHeadingColor))),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                    child: Text(
                  course.courseName,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          addCourses(add, context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //DONT REMOVE
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (loadingAddCourseData ||
        query == "gfufievkldnvodjsjvkdsnvklnviwehlekwdmcnewklvnlehvldkncken") {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (query.isEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: notAddedCourses.map<Widget>((MyCourse course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      );
    } else {
      final suggestionList = notAddedCourses
          .where((MyCourse course) => ((course.courseCode.toLowerCase())
                  .startsWith(query.toLowerCase()) ||
              (course.courseName.toLowerCase())
                  .startsWith(query.toLowerCase())))
          .toList();

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: suggestionList.map<Widget>((MyCourse course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      );
    }
  }
}
