import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:csv/csv.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:instiapp/utilities/constants.dart';
import 'package:connectivity/connectivity.dart';

class ScheduleContainer {
  bool eventsReady = false;

  List<Course> courses = [];
  List<Course> coursesWithoutRepetition = [];
  List<calendar.Event> events;
  List<calendar.Event> eventsWithoutRepetition;

  List<List<TodayCourse>> todayCourses;
  List<EventModel> removedEvents;
  List<MyCourse> userAddedCourses;
  List<List<EventModel>> userCourses;
  List<MyCourse> allCourses;
  List<EventModel> examCourses;
  List<List<EventModel>> eventsList;
  List<EventModel> twoEvents;

  getData() {
    loadCourseTimeData();
    loadAllCourseData();
    loadRemovedCoursesData();
    loadUserAddedCoursesData();
    loadExamTimeTableData();
  }

  readyEvents() {
    prepareEventsList();
    twoEvents = makeListOfTwoEvents();
  }

  Future getEventsCached() async {
    var file = await localFile('events');
    bool exists = await file.exists();
    if (exists) {
      // print("EVENTS CACHED PREVIOUSLY");
      await file.open();
      String events = await file.readAsString();
      List<calendar.Event> eventsList = [];
      var json = jsonDecode(events);
      json['key'].forEach((eventJson) {
        calendar.Event x = calendar.Event.fromJson(eventJson);
        eventsList.add(x);
      });
      return eventsList;
    } else {
      // print("EVENTS NOT CACHED PREVIOUSLY");
    }

    return false;
  }

  Future storeEventsCached() async {
    var file = await localFile('events');
    bool exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    await file.create();
    await file.open();
    List<Map<String, dynamic>> eventList = [];
    events.forEach((element) {
      eventList.add(element.toJson());
    });
    Map<String, dynamic> list = {'key': eventList};
    await file.writeAsString(jsonEncode(list));
    // print("WROTE EVENTS TO CACHE");
    return true;
  }

  Future getEventsOnline(httpClient) async {
    var eventData =
        await calendar.CalendarApi(httpClient).events.list('primary');
    events = [];
    events.addAll(eventData.items);
    eventsWithoutRepetition = listWithoutRepetitionEvent(events);
  }

  Future reloadEventsAndCourses() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      events = [];
      eventsWithoutRepetition = [];
      eventsReady = true;
    } else {
      await dataContainer.auth.gSignIn.signIn();
      final authHeaders =
          await dataContainer.auth.gSignIn.currentUser.authHeaders;
      final httpClient = GoogleHttpClient(authHeaders);
      await getEventsCached().then((values) async {
        if (values != false) {
          // print("Cached Events");
          events = values;
          eventsWithoutRepetition = listWithoutRepetitionEvent(events);
        } else {
          // print("Not cached events");
          await getEventsOnline(httpClient).then((value) {
            storeEventsCached();
          });
        }
      });
      getEventsOnline(httpClient).then((value) {
        storeEventsCached();
      });

      eventsReady = true;
    }
  }

  List listWithoutRepetitionCourse(List<Course> courses) {
    List<Course> withoutRepeat = [];
    courses.forEach((Course course) {
      bool notHave = true;
      withoutRepeat.forEach((Course _course) {
        if (_course.id == course.id) {
          notHave = false;
        }
      });
      if (notHave) {
        withoutRepeat.add(course);
      }
    });
    return withoutRepeat;
  }

  List listWithoutRepetitionEvent(List<calendar.Event> events) {
    List<calendar.Event> withoutRepeat = [];
    events.forEach((calendar.Event event) {
      bool notHave = true;
      withoutRepeat.forEach((calendar.Event _event) {
        if (_event.id == event.id) {
          notHave = false;
        }
      });
      if (notHave) {
        withoutRepeat.add(event);
      }
    });
    return withoutRepeat;
  }

  loadExamTimeTableData() async {
    sheet.getData('ExamTimeTable!A:H').listen((data) {
      examCourses = makeMyExamCoursesList(data, coursesWithoutRepetition);
    });
  }

  List<EventModel> makeMyExamCoursesList(List data, List<Course> _courses) {
    List<EventModel> myExamCourses = [];

    if (_courses != null) {
      _courses.forEach((Course course) {
        bool mine = false;
        var baseLc = data[3];
        data.forEach((var lc) {
          if (mine == false && lc.length > 3) {
            if (lc[0] != '' && lc[0] != '-' && lc[1] != '' && lc[1] != '-') {
              baseLc = lc;
            }
            if (lc[2] != '' && lc[2] != '-') {
              if (lc[2].replaceAll(' ', '').contains(new RegExp(
                      course.name.replaceAll(' ', ''),
                      caseSensitive: false)) ||
                  course.name.replaceAll(' ', '').contains(new RegExp(
                      lc[2].replaceAll(' ', ''),
                      caseSensitive: false)) ||
                  compareStrings(course.name, lc[2]) ||
                  lc[3].replaceAll(' ', '').contains(new RegExp(
                      course.name.replaceAll(' ', ''),
                      caseSensitive: false)) ||
                  course.name.replaceAll(' ', '').contains(new RegExp(
                      lc[3].replaceAll(' ', ''),
                      caseSensitive: false)) ||
                  compareStrings(course.name, lc[3])) {
                List<DateTime> time = getTime(baseLc);
                lc.addAll(['null', 'null', 'null', 'null', 'null']);
                myExamCourses.add(EventModel(
                  isCourse: false,
                  isExam: true,
                  start: time[0],
                  end: time[1],
                  courseId: lc[2],
                  courseName: lc[3],
                  location: lc[5].toString(),
                  rollNumbers: lc[7].toString(),
                  eventType: 'Exam',
                ));
                mine = true;
              }
            }
          }
        });
      });
    }

    return myExamCourses;
  }

  Map<String, int> monthData = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  List<DateTime> getTime(var baseLc) {
    int index = 1;

    var date = baseLc[0].split(',');
    var dayWithMonth = date[1].split(' ');
    if (dayWithMonth.length == 2) {
      index = 0;
    }
    int year = int.parse(date[2].replaceAll(' ', ''));
    int day = int.parse(dayWithMonth[index + 1].replaceAll(' ', ''));
    int month = monthData[dayWithMonth[index].replaceAll(' ', '')];
    var dayTime = baseLc[1].split('-');
    var startTime = dayTime[0].replaceAll(' ', '').split(':');
    var endTime = dayTime[1].replaceAll(' ', '').split(':');
    int startHour = int.parse(startTime[0]);
    int startMinute = int.parse(startTime[1].substring(0, 2));
    int endHour = int.parse(endTime[0]);
    int endMinute = int.parse(endTime[1].substring(0, 2));
    List<DateTime> time = [
      DateTime(year, month, day, startHour, startMinute),
      DateTime(year, month, day, endHour, endMinute)
    ];
    return time;
  }

  loadRemovedCoursesData() async {
    getRemovedEventsData().listen((data) {
      removedEvents = makeRemovedEventsList(data);
    });
  }

  List<EventModel> makeRemovedEventsList(var removedEventsDataList) {
    List<EventModel> _removedEvents = [];

    if (removedEventsDataList != null && removedEventsDataList.length != 0) {
      removedEventsDataList.forEach((var lc) {
        if (lc[0] == 'course') {
          _removedEvents.add(EventModel(
            isCourse: true,
            isExam: false,
            courseId: lc[1],
            courseName: lc[2],
            eventType: lc[3],
          ));
        } else if (lc[0] == 'exam') {
          _removedEvents.add(EventModel(
            isCourse: false,
            isExam: true,
            courseId: lc[1],
            courseName: lc[2],
            eventType: lc[3],
          ));
        } else {
          _removedEvents.add(EventModel(
            isCourse: false,
            isExam: false,
            description: lc[1],
            summary: lc[2],
            location: lc[3],
            creator: lc[4],
            remarks: lc[5],
          ));
        }
      });
    }

    return _removedEvents;
  }

  Stream<List<List<dynamic>>> getRemovedEventsData() async* {
    var file = await localFile('removedCourses');
    bool exists = await file.exists();
    if (exists) {
      await file.open();
      String values = await file.readAsString();
      List<List<dynamic>> rowsAsListOfValues =
          CsvToListConverter().convert(values);
      // print("FROM LOCAL: ${rowsAsListOfValues[2]}");

      yield rowsAsListOfValues;
    } else {
      yield [];
    }
  }

  loadUserAddedCoursesData() async {
    getUserAddedCoursesData().listen((data) {
      userAddedCourses = makeUserAddedCoursesList(data);
    });
  }

  List<MyCourse> makeUserAddedCoursesList(var userAddedCoursesDataList) {
    List<MyCourse> _userAddedCourses = [];

    if (userAddedCoursesDataList != null &&
        userAddedCoursesDataList.length != 0) {
      userAddedCoursesDataList.forEach((var lc) {
        _userAddedCourses.add(MyCourse(
            courseCode: lc[0],
            courseName: lc[1],
            noOfLectures: lc[2].toString(),
            noOfTutorials: lc[3].toString(),
            credits: lc[4].toString(),
            instructors: lc[5].split(','),
            preRequisite: lc[6],
            lectureCourse: lc[7].split('(')[0].replaceAll(' ', '').split(','),
            lectureLocation: returnLocation(lc[7]),
            tutorialCourse: lc[8].split('(')[0].replaceAll(' ', '').split(','),
            tutorialLocation: returnLocation(lc[8]),
            labCourse: lc[9].split('(')[0].replaceAll(' ', '').split(','),
            labLocation: returnLocation(lc[9]),
            remarks: lc[10],
            courseBooks: lc[11],
            links: lc[12].replaceAll(' ', '').split(',')));
      });
    }

    return _userAddedCourses;
  }

  Stream<List<List<dynamic>>> getUserAddedCoursesData() async* {
    var file = await localFile('userAddedCourses');
    bool exists = await file.exists();
    if (exists) {
      await file.open();
      String values = await file.readAsString();
      List<List<dynamic>> rowsAsListOfValues =
          CsvToListConverter().convert(values);
      // print("FROM LOCAL: ${rowsAsListOfValues[2]}");

      yield rowsAsListOfValues;
    } else {
      yield [];
    }
  }

  loadCourseTimeData() async {
    sheet.getData('slots!A:F').listen((data) {
      todayCourses = makeTodayTimeSlotList(data);
    });
  }

  loadAllCourseData() async {
    sheet.getData('timetable!A:Q').listen((data) {
      allCourses = makeMyCourseList(data);
    });
  }

  bool compareStrings(String str1, String str2) {
    if (str1.compareTo(str2) == 0) {
      return true;
    } else {
      return false;
    }
  }

  List<MyCourse> makeMyCourseList(List data) {
    List<MyCourse> _allCourses = [];
    data.forEach((var lc) {
      if (lc[0] != '-' &&
          lc[0] != '' &&
          lc[1] != '-' &&
          lc[1] != '' &&
          lc[0].toString().toLowerCase() != 'course code') {
        _allCourses.add(MyCourse(
            courseCode: lc[0],
            courseName: lc[1],
            noOfLectures: lc[2].toString(),
            noOfTutorials: lc[3].toString(),
            credits: lc[5].toString(),
            instructors: lc[6].split(','),
            preRequisite: lc[10],
            lectureCourse: lc[11].split('(')[0].replaceAll(' ', '').split(','),
            lectureLocation: returnLocation(lc[11]),
            tutorialCourse: lc[12].split('(')[0].replaceAll(' ', '').split(','),
            tutorialLocation: returnLocation(lc[12]),
            labCourse: lc[13].split('(')[0].replaceAll(' ', '').split(','),
            labLocation: returnLocation(lc[13]),
            remarks: lc[14],
            courseBooks: lc[15],
            links: lc[16].replaceAll(' ', '').split(',')));
      }
    });

    return _allCourses;
  }

  String returnLocation(var text) {
    if (text.split('(').length == 1) {
      return 'None';
    } else {
      return text.split('(')[1].replaceAll(')', '');
    }
  }

  List<List<TodayCourse>> makeTodayTimeSlotList(var courseSlotDataList) {
    List<List<TodayCourse>> courses = [[], [], [], [], [], [], []];

    courseSlotDataList.removeAt(0);
    courseSlotDataList.removeAt(0);

    courseSlotDataList.forEach((var lc) {
      List<DateTime> time = returnTime(lc[0]);
      for (var i = 0; i < 5; i++) {
        courses[i]
            .add(TodayCourse(start: time[0], end: time[1], course: lc[i + 1]));
      }
    });

    return courses;
  }

  List<DateTime> returnTime(String time) {
    List<DateTime> seTime = [];
    DateTime today = DateTime.now();
    var list1 = time.split('-');
    var startString = list1[0].split(':');
    var endString = list1[1].split(':');
    seTime = [
      DateTime(today.year, today.month, today.day, int.parse(startString[0]),
          int.parse(startString[1])),
      DateTime(today.year, today.month, today.day, int.parse(endString[0]),
          int.parse(endString[1]))
    ];

    return seTime;
  }

  List<EventModel> makeListOfTwoEvents() {
    List<EventModel> currentEvents = [];
    DateTime currentTime = DateTime.now();
    int day = DateTime.now().weekday;
    if (eventsList != null && eventsList[day - 1] != null) {
      eventsList[day - 1].forEach((EventModel event) {
        if (currentEvents.length < 2) {
          if (event.end.isAfter(currentTime) ||
              event.start.isAfter(currentTime)) {
            currentEvents.add(event);
          }
        }
      });
    }

    return currentEvents;
  }

  prepareEventsList() {
    List<calendar.Event> todayEvents;
    List<EventModel> currentDayExamCourses;

    userCourses = makeCourseEventModel(todayCourses, userAddedCourses);
    eventsList = [[], [], [], [], [], [], []];
    int index = DateTime.now().weekday - 1;

    for (var i = 0; i < 5; i++) {
      if (userCourses != null) {
        if (userCourses[i] != null) {
          userCourses[i].forEach((EventModel model) {
            bool shouldContain = true;
            if (removedEvents != null) {
              removedEvents.forEach((EventModel removedEvent) {
                if (removedEvent.courseId == model.courseId &&
                    removedEvent.courseName == model.courseName &&
                    removedEvent.eventType == model.eventType) {
                  shouldContain = false;
                }
              });
            }
            if (model.day == DateTime.now().weekday && shouldContain) {
              eventsList[i].add(model);
            }
          });
        }
      }
    }

    currentDayExamCourses = todayExamCourses(examCourses);
    currentDayExamCourses.forEach((EventModel model) {
      bool shouldContain = true;
      if (removedEvents != null) {
        removedEvents.forEach((EventModel removedEvent) {
          if (removedEvent.isExam) {
            if (removedEvent.courseId == model.courseId &&
                removedEvent.courseName == model.courseName) {
              shouldContain = false;
            }
          }
        });
      }
      if (shouldContain) {
        eventsList[index].add(model);
      }
    });

    todayEvents = todayEventsList(eventsWithoutRepetition);
    todayEvents.forEach((calendar.Event event) {
      bool shouldContain = true;
      if (removedEvents != null) {
        removedEvents.forEach((EventModel removedEvent) {
          if (removedEvent.isCourse == false && removedEvent.isExam == false) {
            if (removedEvent.description == event.description &&
                removedEvent.summary == event.summary &&
                removedEvent.location == event.location &&
                removedEvent.creator == event.creator.displayName &&
                removedEvent.remarks == event.status) {
              shouldContain = false;
            }
          }
        });
      }
      if (shouldContain) {
        eventsList[index].add(EventModel(
            start: event.start.dateTime.toLocal(),
            end: event.end.dateTime.toLocal(),
            isCourse: false,
            isExam: false,
            courseName: null,
            description: event.description,
            summary: event.summary,
            location: event.location,
            creator: event.creator.displayName,
            remarks: event.status));
      }
    });

    List<EventModel> monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday;
    monday = (eventsList[0] != null) ? eventsList[0] : [];
    tuesday = (eventsList[1] != null) ? eventsList[1] : [];
    wednesday = (eventsList[2] != null) ? eventsList[2] : [];
    thursday = (eventsList[3] != null) ? eventsList[3] : [];
    friday = (eventsList[4] != null) ? eventsList[4] : [];
    saturday = (eventsList[5] != null) ? eventsList[5] : [];
    sunday = (eventsList[6] != null) ? eventsList[6] : [];

    if (monday != null && monday.length != 0) {
      quickSort(monday, 0, monday.length - 1);
    }
    if (tuesday != null && tuesday.length != 0) {
      quickSort(tuesday, 0, tuesday.length - 1);
    }
    if (wednesday != null && wednesday.length != 0) {
      quickSort(wednesday, 0, wednesday.length - 1);
    }
    if (thursday != null && thursday.length != 0) {
      quickSort(thursday, 0, thursday.length - 1);
    }
    if (friday != null && friday.length != 0) {
      quickSort(friday, 0, friday.length - 1);
    }
    if (saturday != null && saturday.length != 0) {
      quickSort(saturday, 0, saturday.length - 1);
    }
    if (sunday != null && sunday.length != 0) {
      quickSort(sunday, 0, sunday.length - 1);
    }

    eventsList = [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday
    ];
  }

  List<EventModel> todayExamCourses(List<EventModel> examCourses) {
    List<EventModel> todayExamCourses = [];
    DateTime today = DateTime.now();
    if (examCourses != null) {
      examCourses.forEach((EventModel event) {
        if (event.start.year == today.year &&
            event.start.month == today.month &&
            event.start.day == today.day) {
          todayExamCourses.add(event);
        }
      });
    }
    return todayExamCourses;
  }

  String returnText(String text) {
    if (text.length > 2) {
      return text.substring(0, 2);
    } else {
      return text;
    }
  }

  List<List<EventModel>> makeCourseEventModel(
      List<List<TodayCourse>> todayCourses, List<MyCourse> myCourses) {
    List<List<EventModel>> coursesEventModelList = [[], [], [], [], [], [], []];

    for (var i = 0; i < 5; i++) {
      if (todayCourses != null && todayCourses.length != 0) {
        if (todayCourses[i] != null && todayCourses[i].length != 0) {
          todayCourses[i].forEach((TodayCourse todayCourse) {
            if (myCourses != null) {
              myCourses.forEach((MyCourse myCourse) {
                myCourse.lectureCourse.forEach((String text) {
                  if (text == todayCourse.course ||
                      text == todayCourse.course.substring(0, 1) ||
                      returnText(text) == todayCourse.course ||
                      returnText(text) == todayCourse.course.substring(0, 1)) {
                    if (text.length > 2) {
                      coursesEventModelList[i].add(EventModel(
                          start: todayCourse.start,
                          end: todayCourse.end,
                          day: DateTime.now().weekday,
                          isCourse: true,
                          isExam: false,
                          courseId: myCourse.courseCode,
                          courseName: myCourse.courseName,
                          eventType:
                              'Lecture ${text.substring(2, text.length)}',
                          location: myCourse.lectureLocation,
                          instructors: myCourse.instructors,
                          credits: myCourse.credits,
                          preRequisite: myCourse.preRequisite,
                          links: myCourse.links,
                          attendanceManager: attendanceData));
                    } else {
                      coursesEventModelList[i].add(EventModel(
                          start: todayCourse.start,
                          end: todayCourse.end,
                          day: DateTime.now().weekday,
                          isCourse: true,
                          isExam: false,
                          courseId: myCourse.courseCode,
                          courseName: myCourse.courseName,
                          eventType: 'Lecture',
                          location: myCourse.lectureLocation,
                          instructors: myCourse.instructors,
                          credits: myCourse.credits,
                          preRequisite: myCourse.preRequisite,
                          links: myCourse.links,
                          attendanceManager: attendanceData));
                    }
                  }
                });
                myCourse.tutorialCourse.forEach((String text) {
                  if (text == todayCourse.course ||
                      text == todayCourse.course.substring(0, 1) ||
                      returnText(text) == todayCourse.course ||
                      returnText(text) == todayCourse.course.substring(0, 1)) {
                    if (text.length > 2) {
                      coursesEventModelList[i].add(EventModel(
                          start: todayCourse.start,
                          end: todayCourse.end,
                          day: DateTime.now().weekday,
                          isCourse: true,
                          isExam: false,
                          courseId: myCourse.courseCode,
                          courseName: myCourse.courseName,
                          eventType:
                              'Tutorial ${text.substring(2, text.length)}',
                          location: myCourse.tutorialLocation,
                          instructors: myCourse.instructors,
                          credits: myCourse.credits,
                          preRequisite: myCourse.preRequisite,
                          links: myCourse.links,
                          attendanceManager: attendanceData));
                    } else {
                      coursesEventModelList[i].add(EventModel(
                          start: todayCourse.start,
                          end: todayCourse.end,
                          day: DateTime.now().weekday,
                          isCourse: true,
                          isExam: false,
                          courseId: myCourse.courseCode,
                          courseName: myCourse.courseName,
                          eventType: 'Tutorial',
                          location: myCourse.tutorialLocation,
                          instructors: myCourse.instructors,
                          credits: myCourse.credits,
                          preRequisite: myCourse.preRequisite,
                          links: myCourse.links,
                          attendanceManager: attendanceData));
                    }
                  }
                });
                myCourse.labCourse.forEach((String text) {
                  if (text == todayCourse.course ||
                      text == todayCourse.course.substring(0, 1) ||
                      returnText(text) == todayCourse.course ||
                      returnText(text) == todayCourse.course.substring(0, 1)) {
                    if (text.length > 2) {
                      coursesEventModelList[i].add(EventModel(
                          start: todayCourse.start,
                          end: todayCourse.end,
                          day: DateTime.now().weekday,
                          isCourse: true,
                          isExam: false,
                          courseId: myCourse.courseCode,
                          courseName: myCourse.courseName,
                          eventType: 'Lab ${text.substring(2, text.length)}',
                          location: myCourse.labLocation,
                          instructors: myCourse.instructors,
                          credits: myCourse.credits,
                          preRequisite: myCourse.preRequisite,
                          links: myCourse.links,
                          attendanceManager: attendanceData));
                    } else {
                      coursesEventModelList[i].add(EventModel(
                          start: todayCourse.start,
                          end: todayCourse.end,
                          day: DateTime.now().weekday,
                          isCourse: true,
                          isExam: false,
                          courseId: myCourse.courseCode,
                          courseName: myCourse.courseName,
                          eventType: 'Lab',
                          location: myCourse.labLocation,
                          instructors: myCourse.instructors,
                          credits: myCourse.credits,
                          preRequisite: myCourse.preRequisite,
                          links: myCourse.links,
                          attendanceManager: attendanceData));
                    }
                  }
                });
              });
            }
          });
        }
      }
    }

    return coursesEventModelList;
  }

  List todayEventsList(List<calendar.Event> _events) {
    List<calendar.Event> todayEvents = [];
    if (_events != null) {
      _events.forEach((calendar.Event _event) {
        bool included = false;
        if (_event.start != null) {
          if (_event.start.dateTime != null) {
            DateTime today = DateTime.now();
            DateTime eventStartTime = _event.start.dateTime;
            if (eventStartTime.year == today.year &&
                eventStartTime.month == today.month &&
                eventStartTime.day == today.day) {
              todayEvents.add(_event);
              included = true;
            }
          }
        }
        if (included == false) {
          if (_event.end != null) {
            if (_event.end.dateTime != null) {
              DateTime today = DateTime.now();
              DateTime eventEndTime = _event.end.dateTime;
              if (eventEndTime.year == today.year &&
                  eventEndTime.month == today.month &&
                  eventEndTime.day == today.day) {
                todayEvents.add(_event);
              }
            }
          }
        }
      });
    }
    return todayEvents;
  }

  int partition(List<EventModel> list, int low, int high) {
    if (list == null || list.length == 0) return 0;
    DateTime pivot = list[high].start;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].start.isBefore(pivot) ||
          list[j].start.isAtSameMomentAs(pivot)) {
        i++;
        swap(list, i, j);
      }
    }
    swap(list, i + 1, high);
    return i + 1;
  }

  void swap(List<EventModel> list, int i, int j) {
    EventModel temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  void quickSort(List<EventModel> list, int low, int high) {
    if (low < high) {
      int pi = partition(list, low, high);
      quickSort(list, low, pi - 1);
      quickSort(list, pi + 1, high);
    }
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
