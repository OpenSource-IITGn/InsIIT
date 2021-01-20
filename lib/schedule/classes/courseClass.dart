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
    String code = row[0].toString().replaceAll(' ', '');

    Course course = Course(
        code: code,
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

  Future<void> navigateToDetail(context) async {
    await Navigator.pushNamed(context, '/eventdetail', arguments: {
      'event': this,
    });
  }

  @override
  Widget buildEventCard(BuildContext context, {Function callBack}) {
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
            navigateToDetail(context).then((val) {
              callBack();
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
                          Text("$code",
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
  Widget buildEventDetails(BuildContext context, {Function callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
                "${code.substring(0, 2)} ${code.substring(2)} | ${name}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textHeadingColor)),
          ),
          ListTile(
              title: Text('Slot type  : ${getCourseType()}',
                  style: TextStyle(color: theme.textHeadingColor))),
          ListTile(
            title: Text(
                "Start         : ${formatDate(startTime, [HH, ':', nn])}",
                style: TextStyle(color: theme.textHeadingColor)),
            trailing: Icon(Icons.edit, color: theme.iconColor),
            onTap: () {
              pickDate(context, startTime).then((time) {
                if (time != null) {
                  startTime = DateTime(startTime.year, startTime.month,
                      startTime.day, time.hour, time.minute);
                  callback();
                }
              });
            },
          ),
          ListTile(
            title: Text(
                "End           : ${formatDate(endTime, [HH, ':', nn])} ",
                style: TextStyle(color: theme.textHeadingColor)),
            trailing: Icon(Icons.edit, color: theme.iconColor),
            onTap: () {
              pickDate(context, endTime).then((time) {
                if (time != null) {
                  endTime = DateTime(endTime.year, endTime.month, endTime.day,
                      time.hour, time.minute);
                  callback();
                }
              });
            },
          ),
          ListTile(
              title: Text(
                  'L-T-P-C      : ${ltpc[0]} - ${ltpc[1]} - ${ltpc[2]} - ${ltpc[3]}',
                  style: TextStyle(color: theme.textHeadingColor))),
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
          (minor == null)
              ? Container()
              : ListTile(
                  title: Text('Minor        : $minor',
                      style: TextStyle(color: theme.textHeadingColor))),

          ListTile(
            title: Text('Instructors',
                style: TextStyle(
                    color: theme.textHeadingColor,
                    fontWeight: FontWeight.bold)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
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
          ),

          // (prerequisite == '-')
          //     ? Container()
          //     : Text('Pre-requisite: $prerequisite',
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 16,
          //             color: theme.textHeadingColor)),
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
