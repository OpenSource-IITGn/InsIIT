import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:instiapp/schedule/screens/editEvent.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';

class CustomSearch extends SearchDelegate {
  var thisTheme = lightTheme;
  addCourses(Map<CourseModel, bool> add, BuildContext context) {
    loadingAddCourseData = true;
    query = "gfufievkldnvodjsjvkdsnvklnviwehlekwdmcnewklvnlehvldkncken";
    add.forEach((CourseModel course, bool addCourse) {
      if (addCourse) {
        addIfNotPresent(course);
      }
    });

    saveFileInCache(context);
  }

  addIfNotPresent(CourseModel course) {
    bool add = true;
    if (dataContainer.schedule.userAddedCourses != null) {
      dataContainer.schedule.userAddedCourses.forEach((CourseModel _course) {
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

  List<List<String>> makeUserAddedCoursesList(
      List<CourseModel> userAddedCourses) {
    List<List<String>> userAddedCoursesList = [];

    userAddedCourses.forEach((CourseModel course) {
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

  Widget courseCard(CourseModel course, Map<CourseModel, bool> add) {
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
            children: notAddedCourses.map<Widget>((CourseModel course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      );
    } else {
      final suggestionList = notAddedCourses
          .where((CourseModel course) => ((course.courseCode.toLowerCase())
                  .startsWith(query.toLowerCase()) ||
              (course.courseName.toLowerCase())
                  .startsWith(query.toLowerCase())))
          .toList();

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: suggestionList.map<Widget>((CourseModel course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      );
    }
  }
}
