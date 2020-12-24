//import 'package:flutter/material.dart';
//import 'package:instiapp/classes/scheduleModel.dart';
//import 'package:instiapp/screens/homePage.dart';
//import 'dart:io';
//import 'package:csv/csv.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:instiapp/utilities/constants.dart';
//import 'package:path_provider/path_provider.dart';
//
//class AddCourse extends StatefulWidget {
//  @override
//  _AddCourseState createState() => _AddCourseState();
//}
//
//List<MyCourse> notAddedCourses = [];
//Map<MyCourse, bool> add = {};
//bool loadingAddCourseData = false;
//
//class _AddCourseState extends State<AddCourse> {
//
//  @override
//  void initState() {
//    super.initState();
//    notAddedCourses = makeNotAddedCoursesList(userAddedCourses, allCourses);
//    add = makeAddMap(notAddedCourses);
//  }
//
//  List<MyCourse> makeNotAddedCoursesList(
//      List<MyCourse> myCourses, List<MyCourse> allCourses) {
//    List<MyCourse> remainingCourses = [];
//
//    allCourses.forEach((MyCourse course) {
//      bool contain = true;
//      if (userAddedCourses != null) {
//        myCourses.forEach((MyCourse addedCourse) {
//          if (addedCourse.courseCode == course.courseCode ||
//              addedCourse.courseName == course.courseName) {
//            contain = false;
//          }
//        });
//      }
//
//      if (contain) {
//        remainingCourses.add(course);
//      }
//    });
//
//    return remainingCourses;
//  }
//
//  Map<MyCourse, bool> makeAddMap(List<MyCourse> remainingCourses) {
//    Map<MyCourse, bool> _add = {};
//    remainingCourses.forEach((MyCourse course) {
//      _add.putIfAbsent(course, () => false);
//    });
//
//    return _add;
//  }
//
//  addCourses (Map<MyCourse, bool> add) {
//    loadingAddCourseData = true;
//    add.forEach((MyCourse course, bool addCourse) {
//      if (addCourse) {
//    saveFileInCache();
//  }
//
//  addIfNotPresent(MyCourse course) {
//    bool add = true;
//    if (userAddedCourses != null) {
//      userAddedCourses.forEach((MyCourse _course) {
//        if (course.courseName == _course.courseName ||
//            course.courseCode == _course.courseCode) {
//          add = false;
//        }
//      });
//    } else {
//      userAddedCourses = [];
//    }
//
//    if (add) {
//      userAddedCourses.add(course);
//    }
//  }
//
//  saveFileInCache() async {
//    var file = await _localFileForUserAddedCourses();
//    bool exists = await file.exists();
//    if (exists) {
//      await file.delete();
//    }
//    await file.create();
//    await file.open();
//    var userAddedCoursesList = makeUserAddedCoursesList(userAddedCourses);
//    await file
//        .writeAsString(ListToCsvConverter().convert(userAddedCoursesList));
//    // print('DATA OF ADDED EVENT STORED IN FILE');
//
//    Navigator.popAndPushNamed(context, '/menuBarBase');
//    //Navigator.popUntil(context, ModalRoute.withName('/menuBarBase'));
//  }
//
//  List<List<String>> makeUserAddedCoursesList(List<MyCourse> userAddedCourses) {
//    List<List<String>> userAddedCoursesList = [];
//
//    userAddedCourses.forEach((MyCourse course) {
//      userAddedCoursesList.add([
//        course.courseCode,
//        course.courseName,
//        course.noOfLectures.toString(),
//        course.noOfTutorials.toString(),
//        course.credits.toString(),
//        course.instructors.join(','),
//        course.preRequisite,
//        course.lectureCourse.join(',') + '(' + course.lectureLocation + ')',
//        course.tutorialCourse.join(',') + '(' + course.tutorialLocation + ')',
//        course.labCourse.join(',') + '(' + course.labLocation + ')',
//        course.remarks,
//        course.courseBooks,
//        course.links.join(',')
//      ]);
//    });
//
//    return userAddedCoursesList;
//  }
//
//  Future<File> _localFileForUserAddedCourses() async {
//    Directory tempDir = await getTemporaryDirectory();
//    String tempPath = tempDir.path;
//    String filename = tempPath + 'userAddedCourses' + '.csv';
//    return File(filename);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: (darkMode)?backgroundColorDarkMode:backgroundColor,
//      appBar: AppBar(
//        elevation: 0,
//        centerTitle: true,
//        backgroundColor: (darkMode)?navBarDarkMode:navBar,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back, color: Colors.black),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//        title: Text('Add Course',
//            style: TextStyle(color: (darkMode)?primaryTextColorDarkMode:primaryTextColor, fontWeight: FontWeight.bold)),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.search,
//              color: Colors.black,
//            ),
//            onPressed: () {
//              showSearch(
//                context: context,
//                delegate: CustomSearch(),
//              );
//            },
//          ),
//        ],
//      ),
////      body: (loading)
////          ? Center(child: CircularProgressIndicator(),)
////          :SingleChildScrollView(
////        child: Padding(
////          padding: const EdgeInsets.all(8.0),
////          child: Column(
////            children: notAddedCourses.map<Widget>((MyCourse course) {
////              return courseCard(course, add);
////            }).toList(),
////          ),
////        ),
////      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          showDialog(
//            context: context,
//            builder: (_) => new AlertDialog(
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: () {
//                    Navigator.pop(context);
//                    addCourses(add);
//                  },
//                  child: Text('Yes'),
//                )
//              ],
//              content: Text(
//                'Do you want to add selected courses to your timetable?'
//              ),
//            ),
//          );
//        },
//        backgroundColor: primaryColor,
//        child: Icon(Icons.add, color: Colors.white),
//      ),
//    );
//  }
//}
//
//class CustomSearch extends SearchDelegate {
//  var suggestion = ["ahmed", "ali", "mohammad"];
//  List<String> searchResult = List();
//
//  Widget courseCard (MyCourse course, Map<MyCourse, bool> add) {
//    return GestureDetector(
//      onTap: () {
//        if (add[course]) {
//          add[course] = false;
//        } else {
//          add[course] = true;
//        }
//
//        query = '';
//      },
//      child: Container(
//        width: ScreenSize.size.width * 1,
//        child: Card(
//          color: (add[course]) ? Colors.white30 : Colors.white,
//          child: Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Flexible(
//                    child: Text(
//                      course.courseCode,
//                      style: TextStyle(
//                          color: (darkMode)?secondaryTextColorDarkMode:secondaryTextColor,
//                          fontSize: 15),
//                    )),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    return [
//      IconButton(
//        icon: Icon(Icons.clear),
//        onPressed: () {
//          query = '';
//        },
//      ),
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    return IconButton(
//      icon: AnimatedIcon(
//        icon: AnimatedIcons.menu_arrow,
//        progress: transitionAnimation,
//      ),
//      onPressed: () {
//        close(context, null);
//      },
//    );
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    //DONT REMOVE
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    if (loadingAddCourseData) {
//      return Center(child: CircularProgressIndicator(),);
//    } else if (query.isEmpty) {
//      return SingleChildScrollView(
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Column(
//            children: notAddedCourses.map<Widget>((MyCourse course) {
//              return courseCard(course, add);
//            }).toList(),
//          ),
//        ),
//      );
//    } else {
//      final suggestionList = notAddedCourses.where((MyCourse course) => ((course.courseCode.toLowerCase()).startsWith(query.toLowerCase()) || (course.courseName.toLowerCase()).startsWith(query.toLowerCase()))).toList();
//
//      return SingleChildScrollView(
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Column(
//            children: suggestionList.map<Widget>((MyCourse course) {
//              return courseCard(course, add);
//            }).toList(),
//          ),
//        ),
//      );
//    }
//  }
//}
