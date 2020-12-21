import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/screens/homePage.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {

  List<MyCourse> notAddedCourses;
  Map<MyCourse, bool> add;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    notAddedCourses = makeNotAddedCoursesList(userAddedCourses, allCourses);
    add = makeAddMap(notAddedCourses);
  }

  List<MyCourse> makeNotAddedCoursesList (List<MyCourse> myCourses, List<MyCourse> allCourses) {
    List<MyCourse> remainingCourses = [];

    allCourses.forEach((MyCourse course) {
      bool contain = true;
      if (userAddedCourses != null) {
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

  Map<MyCourse, bool> makeAddMap (List<MyCourse> remainingCourses) {
    Map<MyCourse, bool> _add = {};
    remainingCourses.forEach((MyCourse course) {
      _add.putIfAbsent(course, () => false);
    });

    return _add;
  }

  addCourses (Map<MyCourse, bool> add) {
    loading = true;
    setState(() {});
    add.forEach((MyCourse course, bool addCourse) {
      if (addCourse) {
        addIfNotPresent(course);
      }
    });

    saveFileInCache();
  }

  addIfNotPresent (MyCourse course) {
    bool add = true;
    if (userAddedCourses != null) {
      userAddedCourses.forEach((MyCourse _course) {
        if (course.courseName == _course.courseName ||
            course.courseCode == _course.courseCode) {
          add = false;
        }
      });
    } else {
      userAddedCourses = [];
    }

    if (add) {
      userAddedCourses.add(course);
    }
  }

  saveFileInCache () async {
    var file = await _localFileForUserAddedCourses();
    bool exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    await file.create();
    await file.open();
    var userAddedCoursesList =
    makeUserAddedCoursesList(userAddedCourses);
    await file.writeAsString(
        ListToCsvConverter().convert(userAddedCoursesList));
    print('DATA OF ADDED EVENT STORED IN FILE');

    Navigator.popUntil(context, ModalRoute.withName('/menuBarBase'));
  }

  List<List<String>> makeUserAddedCoursesList(List<MyCourse> userAddedCourses) {
    List<List<String>> userAddedCoursesList = [];

    userAddedCourses.forEach((MyCourse course) {
      userAddedCoursesList
          .add([
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

  Widget courseCard (MyCourse course, Map<MyCourse, bool> add) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (add[course]) {
            add[course] = false;
          } else {
            add[course] = true;
          }
        });
      },
      child: Container(
        width: ScreenSize.size.width * 1,
        child: Card(
          color: (add[course])?Colors.white30:Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    course.courseCode,
                    style: TextStyle(
                        color: Colors.black.withAlpha(255),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )
                ),
                SizedBox(width: 5,),
                Flexible(
                    child: Text(
                      course.courseName,
                      style: TextStyle(
                          color: Colors.black.withAlpha(255),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        title: Text('Add Course',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: (loading)
          ? Center(child: CircularProgressIndicator(),)
          :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: notAddedCourses.map<Widget>((MyCourse course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    addCourses(add);
                  },
                  child: Text('Yes'),
                )
              ],
              content: Text(
                'Do you want to add selected courses to your timetable?'
              ),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
