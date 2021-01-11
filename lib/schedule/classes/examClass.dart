import 'eventClass.dart';

class Exam extends Event {
  String courseCode;
  String location;
  String courseName;
  Exam({
    name,
    startTime,
    endTime,
    link,
    this.location,
    this.courseCode,
  }) : super(name: name, startTime: startTime, link: link, endTime: endTime);

  factory Exam.fromSheetRow(List row) {
    var startTime;
    var endTime; //find this from row[0] and row[1]
    return Exam(
        name: row[3],
        startTime: startTime,
        location: row[5],
        endTime: endTime);
  }
}
