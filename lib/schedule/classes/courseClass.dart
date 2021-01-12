import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/data/scheduleContainerNew.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

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
    this.slot,
    this.minor,
    this.cap,
    this.slotType,
    this.prerequisite,
  }) : super(name: name, startTime: startTime, link: link, endTime: endTime);

  String getCourseType() {
    if (slotType == 0) {
      return "Lecture";
    } else if (slotType == 1) {
      return "Tutorial";
    } else {
      return "Lab";
    }
  }

  factory Course.fromSheetRow(List row, var slot, int slotType) {
    var times = [DateTime.now(), DateTime.now()];
    if (slot.runtimeType != String) {
      times[0] = ScheduleContainerActual.getTimeFromSlot(slot[0])[0];
      times[1] =
          ScheduleContainerActual.getTimeFromSlot(slot[slot.length - 1])[1];
      slot = slot.join('+');
    } else {
      times = ScheduleContainerActual.getTimeFromSlot(slot);
    }
    return Course(
        code: row[0].toString(),
        name: row[1].toString(),
        ltpc: [
          row[2].toString(),
          row[3].toString(),
          row[4].toString(),
          row[5].toString()
        ],
        startTime: times[0],
        endTime: times[1],
        instructors: row[6].toString(),
        slotType: slotType,
        minor: row[7].toString(),
        cap: row[8].toString(),
        prerequisite: row[9].toString(),
        enrolled: false,
        slot: slot.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'enrolled': enrolled,
      'ltpc': ltpc,
      'code': code,
      'slot': slot,
      'minor': minor,
      'instructors': instructors,
      'cap': cap,
      'prerequisite': prerequisite,
      'slotType': slotType,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  Widget buildEventCard() {
    String startTimeString = formatDate(startTime, [HH, ':', nn]);
    String endTimeString = formatDate(endTime, [HH, ':', nn]);
    bool ongoing =
        DateTime.now().isBefore(endTime) && startTime.isBefore(DateTime.now());

    return Card(
      color: theme.cardBgColor,
      child: Container(
        width: ScreenSize.size.width,
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed('/eventdetail', arguments: {
            //   'eventModel': this,
            // });
          },
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(startTimeString),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to",
                        style: TextStyle(
                            fontSize: 14, color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(endTimeString),
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
}
