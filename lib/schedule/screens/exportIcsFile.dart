//import 'dart:io';
//import 'package:flutter/services.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:instiapp/classes/scheduleModel.dart';
//import 'package:instiapp/utilities/constants.dart';
//import 'package:downloads_path_provider/downloads_path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//class ExportIcsFile extends StatefulWidget {
//  @override
//  _ExportIcsFileState createState() => _ExportIcsFileState();
//}
//
//class _ExportIcsFileState extends State<ExportIcsFile> {
//  Map coursesList = {};
//  bool loading = false;
//  List<EventModel> addedEventModels = [];
//  Directory _downloadsDirectory;
//
//  String writeText(List<EventModel> addedEventModels) {
//    String _text =
//        'BEGIN:VCALENDAR\nPRODID:-//Google Inc//Google Calendar 70.9054//EN\nVERSION:2.0\nCALSCALE:GREGORIAN\nMETHOD:PUBLISH\nX-WR-CALNAME:${currentUser["email"]}\nX-WR-TIMEZONE:Asia/Kolkata\nBEGIN:VTIMEZONE\nTZID:Asia/Kolkata\nX-LIC-LOCATION:Asia/Kolkata\nBEGIN:STANDARD\nTZOFFSETFROM:+0530\nTZOFFSETTO:+0530\nTZNAME:IST\nDTSTART:19700101T000000\nEND:STANDARD\nEND:VTIMEZONE\n';
//    int length = addedEventModels.length;
//    int count = 0;
//    addedEventModels.forEach((EventModel model) {
//      count++;
//      _text += 'BEGIN:VEVENT\n';
//      _text +=
//          'DTSTART;TZID=Asia/Kolkata:${model.start.year}${twoDigitTime(model.start.month.toString())}${twoDigitTime(model.start.day.toString())}T${twoDigitTime(model.start.hour.toString())}${twoDigitTime(model.start.minute.toString())}00\n';
//      _text +=
//          'DTEND;TZID=Asia/Kolkata:${model.end.year}${twoDigitTime(model.end.month.toString())}${twoDigitTime(model.end.day.toString())}T${twoDigitTime(model.end.hour.toString())}${twoDigitTime(model.end.minute.toString())}00\n';
//      if (model.repeatWeekly) {
//        _text += 'RRULE:FREQ=WEEKLY;WKST=MO\n';
//      }
//      _text += 'DESCRIPTION:${model.courseId}\n';
//      _text += 'LOCATION:${model.location}\n';
//      _text += 'SEQUENCE:1\nSTATUS:CONFIRMED\n';
//      _text += 'SUMMARY:${model.courseName}\n';
//      _text += 'TRANSP:OPAQUE\nEND:VEVENT\n';
//      if (count == length) {
//        _text += 'END:VCALENDAR\n';
//      }
//    });
//
//    return _text;
//  }
//
//  Future<void> initDownloadsDirectoryState() async {
//    Directory downloadsDirectory;
//    try {
//      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
//    } on PlatformException {
//      // print('Could not get the downloads directory');
//    }
//    if (!mounted) return;
//
//    setState(() {
//      _downloadsDirectory = downloadsDirectory;
//    });
//  }
//
//  Future<File> getIcsFile() async {
//    String path = _downloadsDirectory.path;
//    String filename = path + '/exportedCourses' + '.ics';
//    // print(path);
//    return File(filename);
//  }
//
//  String twoDigitTime(String text) {
//    if (text.length == 1) {
//      String _text = '0' + text;
//      return _text;
//    } else {
//      return text;
//    }
//  }
//
//  Widget eventCard(EventModel model) {
//    return Container(
//      width: ScreenSize.size.width * 1,
//      child: Card(
//        child: Padding(
//          padding: const EdgeInsets.all(16.0),
//          child: Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Container(
//                width: ScreenSize.size.width * 0.5,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    SizedBox(
//                      height: 8,
//                    ),
//                    Text(
//                      model.courseName,
//                      style: TextStyle(
//                          color: (darkMode)
//                              ? primaryTextColorDarkMode
//                              : primaryTextColor,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15),
//                    ),
//                    // SizedBox(
//                    //   height: 8,
//                    // ),
//                    Text(
//                      (model.eventType != null) ? model.eventType : 'Course',
//                      style: TextStyle(
//                        color: (darkMode)
//                            ? secondaryTextColorDarkMode
//                            : secondaryTextColor,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    SizedBox(
//                      height: 8,
//                    ),
//
//                    SizedBox(
//                      height: 8,
//                    ),
//                  ],
//                ),
//              ),
//              IconButton(
//                onPressed: () {
//                  showDialog(
//                    context: context,
//                    builder: (_) => new AlertDialog(
//                      actions: <Widget>[
//                        FlatButton(
//                          onPressed: () {
//                            Navigator.pop(context);
//                            model.repeatWeekly = true;
//                            addedEventModels.add(model);
//                            setState(() {});
//                          },
//                          child: Text('Yes'),
//                        ),
//                        FlatButton(
//                          onPressed: () {
//                            Navigator.pop(context);
//                            addedEventModels.add(model);
//                            setState(() {});
//                          },
//                          child: Text('No'),
//                        ),
//                      ],
//                      content:
//                          Text('Do you want to make repeat this event weekly?'),
//                    ),
//                  );
//                },
//                icon: Icon(
//                  Icons.add,
//                  color: Colors.black,
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    initDownloadsDirectoryState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    coursesList = ModalRoute.of(context).settings.arguments;
//    List<EventModel> _eventModelList = coursesList['coursesList'];
//    List<EventModel> eventModelList = [];
//    _eventModelList.forEach((EventModel model) {
//      bool contain = true;
//      addedEventModels.forEach((EventModel addedModel) {
//        if (model.courseId == addedModel.courseId &&
//            model.courseName == addedModel.courseName &&
//            model.start == addedModel.start &&
//            model.end == addedModel.end) {
//          contain = false;
//        }
//      });
//      if (contain) {
//        eventModelList.add(model);
//      }
//    });
//
//    return Scaffold(
//      backgroundColor: (darkMode) ? backgroundColorDarkMode : backgroundColor,
//      appBar: AppBar(
//        elevation: 0,
//        centerTitle: true,
//        backgroundColor: (darkMode) ? navBarDarkMode : navBar,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back, color: Colors.black),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//        title: Text('Export',
//            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//      ),
//      body: (loading)
//          ? Center(
//              child: CircularProgressIndicator(),
//            )
//          : SingleChildScrollView(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Column(
//                  children: <Widget>[
//                    Column(
//                      children: eventModelList.map<Widget>((EventModel model) {
//                        return eventCard(model);
//                      }).toList(),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    RaisedButton.icon(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(16.0),
//                      ),
//                      color: primaryColor,
//                      onPressed: () async {
//                        if (addedEventModels.length == 0) {
//                          setState(() {
//                            showDialog(
//                              context: context,
//                              builder: (_) => new AlertDialog(
//                                content:
//                                    Text('Please select atleast 1 Course!'),
//                              ),
//                            );
//                          });
//                        } else {
//                          loading = true;
//                          setState(() {});
//                          var status = await Permission.storage.status;
//                          if (!status.isGranted) {
//                            await Permission.storage.request();
//                          }
//                          var file = await getIcsFile();
//                          await file.create();
//                          await file.open();
//                          await file.writeAsString(writeText(addedEventModels));
//                          loading = false;
//                          Navigator.popUntil(
//                              context, ModalRoute.withName('/menuBarBase'));
//                        }
//                      },
//                      icon: Icon(
//                        Icons.file_download,
//                        color: Colors.white,
//                      ),
//                      label: Text(
//                        'Export file',
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//    );
//  }
//}
