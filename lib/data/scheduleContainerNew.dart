import 'dart:convert';

import 'package:instiapp/schedule/classes/courseClass.dart';
import 'package:instiapp/schedule/classes/eventClass.dart';
import 'package:instiapp/schedule/classes/examClass.dart';

class ScheduleContainerActual {
  List<List<Course>> enrolledCourses;
  List<List<Course>>
      allCourses; //this is fetched only when new courses are going to be added in the addcourses page
  List<List<Event>> events;
  List<List<Exam>> exams; //this should be based on enrolledCourses
  Map<String, List<DateTime>> slots = {
    'A1': [
      DateTime(2021, 1, 1, 8, 5),
      DateTime(2021, 1, 1, 9, 5)
    ] //8:05 to 9:05

    // GET THIS FROM THE SHEET AND STORE HERE LIKE THIS
  };

  List<DateTime> getTimeFromSlot(String slot) {
    return slots[slot];
  }

  void getData() {
    // check if there is a cached file that has enrolledCourses
    // load all courses from sheets
    // load events from calendar api
    // load exams from sheets
  }

  void storeEnrolledCourses() {
    //do something similar for exams and courses
    List courses = [];
    enrolledCourses.forEach((day) {
      day.forEach((course) {
        courses.add(course.toJson());
      });
    });
    String jsonCourses = jsonEncode(courses);
    //write this string to file

    // create another method that does the jsonDecode and gets back the stuff accurately
  }
}
