import 'dart:convert';

import 'package:color_convert/color_convert.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'package:instiapp/data/scheduleContainer.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eventClass.dart';

//TODO = LINKS??, SORTING
class Course extends Event {
  bool enrolled = false;
  List ltpc = [0, 0, 0, 0];
  String code;
  String slot;
  String minor;
  String instructors;
  String cap;
  String prerequisite;

  int slotType; // 0 = lecture, 1 = tutorial, 2 = lab
  Course({
    this.enrolled,
    this.ltpc,
    this.code,
    name,
    startTime,
    endTime,
    this.instructors,
    link,
    currentlyRunning,
    this.slot,
    this.minor,
    color,
    this.cap,
    this.slotType,
    this.prerequisite,
  }) : super(
            name: name,
            startTime: startTime,
            link: link,
            color: color,
            endTime: endTime,
            currentlyRunning: currentlyRunning);

  String getCourseType() {
    if (slotType == 0) {
      return "Lecture";
    } else if (slotType == 1) {
      return "Tutorial";
    } else {
      return "Lab";
    }
  }

  factory Course.fromSheetRow(List row, var slot, int slotType, int index) {
    var times = [DateTime.now(), DateTime.now()];
    if (slot.runtimeType != String) {
      times[0] = ScheduleContainer.getTimeFromSlot(slot[0])[0];
      times[1] = ScheduleContainer.getTimeFromSlot(slot[slot.length - 1])[1];
      slot = slot.join('+');
    } else {
      times = ScheduleContainer.getTimeFromSlot(slot);
    }
    int hue = 30 * index % 360;
    int sat = 80;
    int illum = 80 - (index ~/ 12) * 10;

    var col = convert.hsv.rgb(hue, sat, illum);
    Course course = Course(
        code: row[0].toString(),
        name: row[1].toString(),
        ltpc: [
          row[2].toString(),
          row[3].toString(),
          row[4].toString(),
          row[5].toString()
        ],
        startTime: times[0],
        color: Color.fromARGB(100, col[0], col[1], col[2]),
        endTime: times[1],
        instructors: row[6].toString(),
        slotType: slotType,
        minor: row[7].toString(),
        cap: row[8].toString(),
        prerequisite: row[9].toString(),
        enrolled: false,
        slot: slot.toString());
    return course;
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'ltpc': ltpc,
      'startTime': [
        startTime.year,
        startTime.month,
        startTime.day,
        startTime.hour,
        startTime.minute
      ],
      'endTime': [
        endTime.year,
        endTime.month,
        endTime.day,
        endTime.hour,
        endTime.minute
      ],
      'instructors': instructors,
      'slotType': slotType,
      'minor': minor,
      'cap': cap,
      'color': color.toString(),
      'prerequisite': prerequisite,
      'enrolled': enrolled,
      'slot': slot
    };
  }

  String toJson() => json.encode(toMap());

  @override
  Widget buildEventCard(BuildContext context) {
    String startTimeString = formatDate(startTime, [HH, ':', nn]);
    String endTimeString = formatDate(endTime, [HH, ':', nn]);
    bool ongoing =
        DateTime.now().isBefore(endTime) && startTime.isBefore(DateTime.now());

    return Card(
      color: color,
      child: Container(
        width: ScreenSize.size.width,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/eventdetail', arguments: {
              'event': this,
            });
          },
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(startTimeString,
                        style: TextStyle(color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to",
                        style: TextStyle(
                            fontSize: 14, color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(endTimeString,
                        style: TextStyle(color: theme.textHeadingColor)),
                  ]),
                  verticalDivider(),
                  // descriptionWidget(),
                  Container(
                    width: ScreenSize.size.width * 0.55,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(code,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: theme.textSubheadingColor)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.textHeadingColor)),
                          SizedBox(
                            height: 8,
                          ),
                          // (this.links != null || this.links.length != 0)
                          //     ? Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: this.links.map((link) {
                          //           return GestureDetector(
                          //             onTap: () async {
                          //               if (await canLaunch(link)) {
                          //                 await launch(link, forceSafariVC: false);
                          //               } else {
                          //                 throw 'Could not launch $link';
                          //               }
                          //             },
                          //             child: Text(
                          //               link,
                          //               style: TextStyle(color: Colors.blue, fontSize: 15),
                          //             ),
                          //           );
                          //         }).toList(),
                          //       )
                          //     : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(getCourseType(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      color: theme.textHeadingColor)),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ]),
                  ),
                  (ongoing == true)
                      ? Icon(
                          Icons.adjust,
                          color: Colors.green,
                        )
                      : Container(),
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget buildEventDetails() {
    String startTimeString = formatDate(startTime, [HH, ':', nn]);
    String endTimeString = formatDate(endTime, [HH, ':', nn]);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("$name",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textHeadingColor)),
          Text(code,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.textSubheadingColor)),
          Text(getCourseType(),
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: theme.textHeadingColor)),
          SizedBox(
            height: 10,
          ),
          (link != null && link.length != 0)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: link.split(',').map((link) {
                    return GestureDetector(
                      onTap: () async {
                        if (await canLaunch(link)) {
                          await launch(link, forceSafariVC: false);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      child: Text(
                        (link == '-') ? "" : link,
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                )
              : Container(),
//          RichText(
//            text: TextSpan(
//              children: <TextSpan>[
//                TextSpan(
//                  text: 'Happens at ',
//                ),
//                TextSpan(
//                  text: location,
//                  style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: theme.textHeadingColor),
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 10,
//          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Between ',
                ),
                TextSpan(
                  text: startTimeString,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: endTimeString,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (minor == null)
              ? Container()
              : Text('Minor: $minor',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.textHeadingColor)),
          SizedBox(
            height: 8,
          ),
          Text('Instructors: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textHeadingColor)),
          SizedBox(
            height: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (instructors == null)
                ? [Container()]
                : instructors.split(',').map<Widget>((String instructor) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        8,
                        0,
                        0,
                        0,
                      ),
                      child: Text(instructor,
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: theme.textSubheadingColor)),
                    );
                  }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          Text('${ltpc[3]} credits',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
          (prerequisite == '-')
              ? Container()
              : Text('Pre-requisite: $prerequisite',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.textHeadingColor)),
          // ExpansionTile(
          //   key: GlobalKey(),
          //   title: Text('View Attendance'),
          //   children: attendance,
          // )
        ],
      ),
    );
  }
}
