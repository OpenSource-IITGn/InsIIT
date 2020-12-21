//import 'package:flutter/material.dart';
//import 'package:instiapp/classes/scheduleModel.dart';
//import 'package:instiapp/screens/homePage.dart';
//import 'dart:io';
//import 'package:csv/csv.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:instiapp/utilities/constants.dart';
//import 'package:path_provider/path_provider.dart';
//
//import '../../classes/scheduleModel.dart';
//
//
//class AddCourse extends StatefulWidget {
//  @override
//  _AddCourseState createState() => _AddCourseState();
//}
//
//class _AddCourseState extends State<AddCourse> {
//
//  bool loading = false;
//
//  EventModel event;
//  TextEditingController _courseIDController;
//  TextEditingController _courseNameController;
//  TextEditingController _locationController;
//  TextEditingController _creditsController;
//  TextEditingController _preRequisiteController;
//
//  void initState() {
//    super.initState();
//    _courseIDController = TextEditingController();
//    _courseNameController = TextEditingController();
//    _locationController = TextEditingController();
//    _creditsController = TextEditingController();
//    _preRequisiteController = TextEditingController();
//    DateTime _currentTime = DateTime.now();
//    startTime = TimeOfDay.fromDateTime(_currentTime);
//    endTime = TimeOfDay.fromDateTime(_currentTime.add(new Duration(hours: 1)));
//  }
//
//  TimeOfDay startTime;
//  TimeOfDay endTime;
//  DateTime start;
//  DateTime end;
//
//  Map<String, int> dayData = {
//    'Monday': 1,
//    'Tuesday': 2,
//    'Wednesday': 3,
//    'Thursday': 4,
//    'Friday': 5,
//    'Saturday': 6,
//    'Sunday': 7
//};
//  String selectedDay = 'Select day';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        elevation: 0,
//        centerTitle: true,
//        backgroundColor: Colors.transparent,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back, color: Colors.black),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//        title: Text('Add Course',
//            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//      ),
//      body: (loading)
//        ? Center(child: CircularProgressIndicator(),)
//        :SingleChildScrollView(
//        child: Padding(
//          padding: const EdgeInsets.all(16.0),
//          child: Column(
//            children: <Widget>[
//              Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Center(
//                    child: Text(
//                      'From: ',
//                      style: TextStyle(
//                          color: Colors.black, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  OutlineButton.icon(
//                    color: Colors.white,
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(16.0),
//                    ),
//                    onPressed: _pickStartTime,
//                    icon: Icon(Icons.access_time, color: Colors.black),
//                    label: Text(
//                      "${startTime.hour.toString().padLeft(2, '0')} : ${startTime.minute.toString().padLeft(2, '0')}",
//                      style: TextStyle(color: Colors.black),
//                    ),
//                  ),
//                  Center(
//                    child: Text(
//                      'To: ',
//                      style: TextStyle(
//                          color: Colors.black, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  OutlineButton.icon(
//                    color: Colors.white,
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(16.0),
//                    ),
//                    onPressed: _pickEndTime,
//                    icon: Icon(Icons.access_time, color: Colors.black),
//                    label: Text(
//                      "${endTime.hour.toString().padLeft(2, '0')} : ${endTime.minute.toString().padLeft(2, '0')}",
//                      style: TextStyle(color: Colors.black),
//                    ),
//                  ),
//                ],
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              ExpansionTile(
//                title: Text(selectedDay),
//                key: GlobalKey(),
//                children: dayData.keys.map((String day) {
//                  return ListTile(
//                    title: Text(day),
//                    onTap: () {
//                      setState(() {
//                        selectedDay = day;
//                      });
//                    },
//                  );
//                }).toList()
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              TextField(
//                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
//                  labelText: 'Course ID',
//                ),
//                controller: _courseIDController,
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              TextField(
//                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
//                  labelText: 'Course Name',
//                ),
//                controller: _courseNameController,
//              ),SizedBox(
//                height: 20.0,
//              ),
//              TextField(
//                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
//                  labelText: 'Location (Optional)',
//                ),
//                controller: _locationController,
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              TextField(
//                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
//                  labelText: 'Credit (Optional)',
//                ),
//                keyboardType: TextInputType.phone,
//                controller: _creditsController,
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              TextField(
//                decoration: InputDecoration(
//                  border: OutlineInputBorder(),
//                  labelText: 'Pre Requisite (Optional)',
//                ),
//                controller: _preRequisiteController,
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              FlatButton.icon(
//                color: primaryColor,
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(16.0),
//                ),
//                icon: Icon(Icons.add, color: Colors.white),
//                onPressed: () async {
//                  if (selectedDay == 'Select day' || _courseIDController.text == '' || _courseNameController.text == '') {
//                    showDialog(
//                      context: context,
//                      builder: (_) => new AlertDialog(
//                        content: Text("Please provide all the necessary information"),
//                      ),
//                    );
//                  } else {
//                    userAddedCourses.add(EventModel(
//                      isCourse: true,
//                      isExam: false,
//                      courseId: _courseIDController.text,
//                      courseName: _courseNameController.text,
//                      location: (_locationController.text == '') ? '-' : _locationController.text,
//                      credits: (_creditsController.text == '') ? '-' : _creditsController.text,
//                      preRequisite: (_preRequisiteController.text == '') ? '-' : _preRequisiteController.text,
//                      start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, startTime.hour, startTime.minute),
//                      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, endTime.hour, endTime.minute),
//                      day: dayData[selectedDay],
//                      attendanceManager: attendanceData,
//                    ));
//                    loading = true;
//                    setState(() {});
//                    var file = await _localFileForUserAddedCourses();
//                    bool exists = await file.exists();
//                    if (exists) {
//                      await file.delete();
//                    }
//                    await file.create();
//                    await file.open();
//                    var userAddedCoursesList =
//                    makeUserAddedCoursesList(userAddedCourses);
//                    await file.writeAsString(
//                        ListToCsvConverter().convert(userAddedCoursesList));
//                    print('DATA OF ADDED EVENT STORED IN FILE');
//                    Navigator.pop(context);
//                  }
//                },
//                label: Text(
//                    'Add Course',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  List<List<String>> makeUserAddedCoursesList(List<EventModel> userAddedCourses) {
//    List<List<String>> userAddedCoursesList = [];
//
//    userAddedCourses.forEach((EventModel model) {
//        userAddedCoursesList
//            .add([model.courseId, model.courseName, model.location, model.credits, model.preRequisite, model.start.hour.toString() + ':' + model.start.minute.toString(), model.end.hour.toString() + ':' + model.end.minute.toString(), model.day.toString()]);
//    });
//
//    return userAddedCoursesList;
//  }
//
//
//  Future<File> _localFileForUserAddedCourses() async {
//    Directory tempDir = await getTemporaryDirectory();
//    String tempPath = tempDir.path;
//    String filename = tempPath + 'userAddedCourses' + '.csv';
//    return File(filename);
//  }
//
//  _pickStartTime() async {
//    TimeOfDay t =
//    await showTimePicker(context: context, initialTime: startTime);
//    if (t != null)
//      setState(() {
//        startTime = t;
//      });
//  }
//
//  _pickEndTime() async {
//    TimeOfDay t = await showTimePicker(context: context, initialTime: endTime);
//    if (t != null)
//      setState(() {
//        endTime = t;
//      });
//  }
//}
