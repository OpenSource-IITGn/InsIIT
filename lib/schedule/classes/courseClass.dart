import 'dart:convert';

import 'eventClass.dart';

class Course extends Event {
  bool enrolled = false;
  List ltpc = [0, 0, 0, 0];
  String code;
  String slot;
  String minor;
  String instructors;
  int cap;
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
    this.prerequisite,
  }) : super(name: name, startTime: startTime, link: link, endTime: endTime);

  factory Course.fromSheetRow(List row, String slot) {
    var times =
        getTimeFromSlot(slot); //this method is there in schedulecontaineractual

    return Course(
        code: row[0],
        name: row[1],
        ltpc: [
          row[2].toInt(),
          row[3].toInt(),
          row[4].toInt(),
          row[5].toInt(),
        ],
        startTime: times[0],
        endTime: times[1],
        instructors: row[6],
        minor: row[7],
        cap: row[8],
        prerequisite: row[9],
        slot: slot);
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
