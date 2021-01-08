import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/themeing/notifier.dart';

Map<DateTime, String> attendanceData = {
  DateTime(2020, 05, 30): 'P',
  DateTime(2020, 05, 31): 'A',
  DateTime(2020, 06, 01): 'P',
  DateTime(2020, 06, 02): 'P',
  DateTime(2020, 06, 03): 'P',
  DateTime(2020, 06, 04): 'A',
  DateTime(2020, 06, 05): 'A',
  DateTime(2020, 06, 06): 'P',
  DateTime(2020, 06, 07): 'A',
  DateTime(2020, 06, 08): 'P',
};

class EventModel {
  DateTime start;
  DateTime end;
  bool isCourse;
  bool isExam;
  bool currentlyRunning;
  String rollNumbers;
  String courseName;
  String courseId;
  String description;
  String summary;
  String eventType;
  String remarks;
  String location;
  String creator;
  List<String> instructors;
  String credits;
  String preRequisite;
  Map<DateTime, String> attendanceManager;
  int day;
  bool repeatWeekly;
  List<String> links;
  EventModel(
      {this.start,
      this.end,
      this.isCourse,
      this.isExam,
      this.currentlyRunning: false,
      this.rollNumbers,
      this.courseName,
      this.courseId,
      this.description,
      this.summary,
      this.eventType,
      this.remarks,
      this.location,
      this.creator,
      this.instructors,
      this.credits,
      this.preRequisite,
      this.attendanceManager,
      this.day,
      this.links,
      this.repeatWeekly: false});

  Widget time(DateTime time) {
    if (time == null) {
      return Flexible(
        child: Text("Whole Day",
            style: TextStyle(fontSize: 17, color: theme.textHeadingColor)),
      );
    } else {
      return Text(
          twoDigitTime(time.hour.toString()) +
              ':' +
              twoDigitTime(time.minute.toString()),
          style: TextStyle(fontSize: 17, color: theme.textHeadingColor));
    }
  }

  int totalAttendance(Map<DateTime, String> attendanceManager) {
    int count = 0;
    attendanceManager.forEach((DateTime time, String attendance) {
      if (attendance == 'P') {
        count++;
      }
    });
    return count;
  }

  String twoDigitTime(String text) {
    if (text.length == 1) {
      String _text = '0' + text;
      return _text;
    } else {
      return text;
    }
  }

  Widget descriptionWidget() {
    if (this.isCourse) {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.courseId,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: theme.textSubheadingColor)),
              SizedBox(
                height: 8,
              ),
              Text(this.courseName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.textHeadingColor)),
              SizedBox(
                height: 8,
              ),
              (this.links != null || this.links.length != 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: this.links.map((link) {
                        return GestureDetector(
                          onTap: () async {
                            if (await canLaunch(link)) {
                              await launch(link, forceSafariVC: false);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          child: Text(
                            link,
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        );
                      }).toList(),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text((this.eventType == null) ? 'Course' : this.eventType,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: theme.textHeadingColor)),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text('Room: ${this.location}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: theme.textHeadingColor)),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              // Text(
              //     'Your attendance: ' +
              //         totalAttendance(this.attendanceManager).toString(),
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
      );
    } else if (this.isExam) {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.courseId,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Text(this.courseName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Text(this.eventType,
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Room: ',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text('Roll Numbers: ',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(this.location,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(this.rollNumbers,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                ],
              ),
            ]),
      );
    } else {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(stringReturn(this.description),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Text(stringReturn(this.summary),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                height: 8,
              ),
              Text(
                  stringReturn(this.eventType) +
                      ' (' +
                      stringReturn(this.remarks) +
                      ')',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
            ]),
      );
    }
  }

  Widget current() {
    if (this.currentlyRunning) {
      return Icon(
        Icons.adjust,
        color: Colors.green,
      );
    } else {
      return Container();
    }
  }

  Widget buildCard(BuildContext context) {
    return Card(
      color: theme.cardBgColor,
      child: Container(
        width: ScreenSize.size.width,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/eventdetail', arguments: {
              'eventModel': this,
            });
          },
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    time(this.start),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to",
                        style: TextStyle(
                            fontSize: 14, color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    time(this.end),
                  ]),
                  verticalDivider(),
                  descriptionWidget(),
                  current(),
                ],
              )),
        ),
      ),
    );
  }
}

class TodayCourse {
  DateTime start;
  DateTime end;
  String course;

  TodayCourse({this.start, this.end, this.course});
}

class CourseModel {
  String courseCode;
  String courseName;
  String noOfLectures;
  String noOfTutorials;
  String credits;
  bool enrolled = false;
  List<String> instructors;
  String preRequisite;
  List<String> lectureCourse;
  String lectureLocation;
  List<String> tutorialCourse;
  String tutorialLocation;
  List<String> labCourse;
  String labLocation;
  String remarks;
  String courseBooks;
  List<String> links;

  CourseModel(
      {this.courseCode,
      this.courseName,
      this.noOfLectures,
      this.noOfTutorials,
      this.credits,
      this.instructors,
      this.preRequisite,
      this.lectureCourse,
      this.lectureLocation,
      this.tutorialCourse,
      this.tutorialLocation,
      this.labCourse,
      this.labLocation,
      this.remarks,
      this.courseBooks,
      this.links});
}
