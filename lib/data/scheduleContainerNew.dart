import 'dart:convert';

import 'package:instiapp/schedule/classes/courseClass.dart';
import 'package:instiapp/schedule/classes/eventClass.dart';
import 'package:instiapp/schedule/classes/examClass.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:developer';

class ScheduleContainerActual {
  List<Course> allCourses = [];
  List allCoursesRows = [];

  // 1 = monday, 2 = tuesday and so on. defined in datetime package
  Map<int, List<Course>> enrolledCourses = {};
  Map<int, List<Course>> events = {};
  Map<int, List<Course>> exams = {};

  static Map<String, List<DateTime>> slots = {};

  static List<DateTime> getTimeFromSlot(String slot) {
    if (slots[slot] == null) {
      return [DateTime(2000, 1, 1), DateTime(2000, 1, 1)];
    }
    return slots[slot];
  }

  ScheduleContainerActual() {
    getSlots();
    for (int i = 0; i < 7; i++) {
      enrolledCourses[i] = [];
    }
  }

  static void getSlots() {
    sheet.getData('slots!A:F').listen((data) {
      //remove useless rows
      data.removeAt(0);
      data.removeAt(0);

      data.forEach((var row) {
        List times = row[0].split('-');
        times[0] = times[0].trim();
        times[1] = times[1].trim();

        for (int i = 1; i < 6; i++) {
          slots[row[i]] = [
            DateTime(2021, 1, 3 + i, int.parse(times[0].split(':')[0]),
                int.parse(times[0].split(':')[1])),
            DateTime(2021, 1, 3 + i, int.parse(times[1].split(':')[0]),
                int.parse(times[1].split(':')[1]))
          ];
        }
      });
    });
  }

  void getData() {
    // check if there is a cached file that has enrolledCourses
    // load all courses from sheets
    // load events from calendar api
    // reloadEvents();
    // load exams from sheets
  }
  List parseSlotString(String slotString) {
    List list = [];
    slotString = slotString.replaceAll(' ', '');
    if (slotString != '-') {
      list = slotString.split(',');
      // print(list);
      List newList = [];
      list.forEach((var clubbedString) {
        clubbedString = clubbedString.split('+');
        if (clubbedString.length == 1) {
          if (clubbedString[0].length == 1) {
            var keys = ScheduleContainerActual.slots.keys.toList();
            for (int i = 0; i < keys.length; i++) {
              if (keys[i][0] == clubbedString[0][0]) {
                newList.add(keys[i]);
              }
            }
          } else {
            newList.add(clubbedString[0]);
          }
        } else {
          newList.add(clubbedString);
        }
      });

      list = newList;
    }
    return list;
  }

  void unEnrollCourse(int index) {
    enrolledCourses[DateTime.now().weekday].removeAt(index);
    storeEnrolledCourses();
  }

  void enrollCourseFromIndex(int index) {
    log('Enrolling course #$index', name: 'COURSES');
    var row = allCoursesRows[index];
    List lecSlots = parseSlotString(row[11]);
    List tutSlots = parseSlotString(row[12]);
    List labSlots = parseSlotString(row[13]);

    lecSlots.forEach((slot) {
      Course course = Course.fromSheetRow(row, slot, 0);
      enrolledCourses[course.startTime.weekday].add(course);
    });
    tutSlots.forEach((slot) {
      Course course = Course.fromSheetRow(row, slot, 1);
      enrolledCourses[course.startTime.weekday].add(course);
    });
    labSlots.forEach((slot) {
      Course course = Course.fromSheetRow(row, slot, 2);
      enrolledCourses[course.startTime.weekday].add(course);
    });
  }

  Future getAllCourses() async {
    await sheet.getDataOnline('timetable!A:Q').then((data) {
      allCourses = [];
      allCoursesRows = [];
      data.removeAt(0);
      data.forEach((var row) {
        allCourses.add(Course.fromSheetRow(row, 'UNEXPANDED', 0));
        allCoursesRows.add(row);
      });
      log("Loaded ${allCourses.length} courses from ${data.length} rows",
          name: 'COURSES');
    });
  }

  //COURSES
  void storeEnrolledCourses() {
    //do something similar for exams and courses
    List courses = [];
    // enrolledCourses.forEach((day) {
    //   day.forEach((course) {
    //     courses.add(course.toJson());
    //   });
    // });
    String jsonCourses = jsonEncode(courses);
    //write this string to file

    // create another method that does the jsonDecode and gets back the stuff accurately
  }

  Future loadUserEnrolledCoursesData() async {
    getCachedData('userEnrolledCourses').then((data) {
      //Have defined getCachedData and storeCachedData functions in GlobalFunctions
      enrolledCourses = data;
      print(enrolledCourses);
    });
  }

  //EVENTS
  // Future reloadEvents() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     events = [[],[],[],[],[],[],[]];
  //   } else {
  //     // await dataContainer.auth.gSignIn.signIn();
  //     //dataContainer.auth.gSignIn.signInSilently().then((value) async {
  //       final authHeaders =
  //       await dataContainer.auth.gSignIn.currentUser.authHeaders;
  //       final httpClient = GoogleHttpClient(authHeaders);
  //       getEventsOnline(httpClient);
  //     //});
  //   }
  // }

  // Future getEventsOnline(httpClient) async {
  //   var eventData =
  //   await calendar.CalendarApi(httpClient).events.list('primary');
  //   List<calendar.Event> tempEvents = [];
  //   tempEvents.addAll(eventData.items);
  //   makeListWithoutRepetitionEvent(tempEvents);
  // }

  // void makeListWithoutRepetitionEvent(List<calendar.Event> tempEvents) {
  //   List<calendar.Event> withoutRepeat = [];
  //   events = [[],[],[],[],[],[],[]];
  //   int day = DateTime.now().weekday;
  //   tempEvents.forEach((calendar.Event event) {
  //     bool notHave = true;
  //     withoutRepeat.forEach((calendar.Event _event) {
  //       if (_event.id == event.id) {
  //         notHave = false;
  //       }
  //     });
  //     if (notHave) {
  //       withoutRepeat.add(event);
  //     }
  //   });

  //   withoutRepeat.forEach((calendar.Event event) {
  //     events[day - 1].add(Event(
  //       startTime: event.start.dateTime.toLocal(),
  //       endTime: event.end.dateTime.toLocal(),
  //       name: event.description,
  //       host: event.creator.displayName,
  //       link: event.htmlLink //TODO: Have to check how to obtain link from calendar.event object
  //     ));
  //   });
  // }
}

// class GoogleHttpClient extends IOClient {
//   Map<String, String> _headers;

//   GoogleHttpClient(this._headers) : super();

//   @override
//   Future<StreamedResponse> send(BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));

//   @override
//   Future<Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }
