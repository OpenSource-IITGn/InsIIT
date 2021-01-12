import 'dart:convert';

import 'package:instiapp/data/scheduleContainerNew.dart';

import 'eventClass.dart';

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
    }
    else{
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

    // if (times[0] == DateTime(2000, 1, 1)) {
    //   print(slot);
    // } else {
    //   print(times);
    // }
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
}
