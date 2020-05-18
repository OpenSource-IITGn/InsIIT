import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/screens/homePage.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

List<EventModel> eventsList;

class _SchedulePageState extends State<SchedulePage> {

  List<Course> _courses;

  List<calendar.Event> todayEvents;
  List<EventModel> currentDayCourses;
  List<EventModel> mergedCourses;
  List<calendar.Event> _events;
  EventModel x = EventModel(
      courseId: "EE333",
      courseName: "Embedded Systems and Microprocessors",
      isCourse: true,
      remarks: 'Bring laptop',
      eventType: 'Lab',
      location: 'Electrical and Electronics Lab');
  @override
  void initState() {
    super.initState();
    eventsList = [];
    currentDayCourses = makeCourseEventModel(todayCourses, myCourses);
    mergedCourses = mergeSameCourses(currentDayCourses);
    mergedCourses.forEach((EventModel model) {
      bool shouldContain = true;
      removedEvents.forEach((EventModel removedEvent) {
        if (removedEvent.isCourse) {
          if (removedEvent.courseId == model.courseId &&
              removedEvent.courseName == model.courseName &&
              removedEvent.eventType == model.eventType) {
            shouldContain = false;
          }
        }
      });
      if (shouldContain) {
        eventsList.add(model);
      }
    });
    _events = listWithoutRepetitionEvent(events);
    todayEvents = todayEventsList(_events);
    todayEvents.forEach((calendar.Event event) {
      bool shouldContain = true;
      removedEvents.forEach((EventModel removedEvent) {
        if (removedEvent.isCourse == false) {
          if (removedEvent.description == event.description &&
              removedEvent.summary == event.summary &&
              removedEvent.location == event.location &&
              removedEvent.creator == event.creator.displayName &&
              removedEvent.remarks == event.status) {
            shouldContain = false;
          }
        }
      });
      if (shouldContain) {
        eventsList.add(EventModel(start: event.start.dateTime.toLocal(),
            end: event.end.dateTime.toLocal(),
            isCourse: false,
            courseName: null,
            description: event.description,
            summary: event.summary,
            location: event.location,
            creator: event.creator.displayName,
            remarks: event.status));
      }
    });
    if (eventsList.length != 0 && eventsList != null) {
      quickSort(eventsList, 0, eventsList.length - 1);
    }
  }

  List<EventModel> mergeSameCourses (List<EventModel> currentDayCourses) {
    List<EventModel> _mergedCourses = [];
    bool notHave;

    if (currentDayCourses.length != 0 && currentDayCourses != null) {
      for (int i = 0; i < currentDayCourses.length; i++) {
        notHave = true;
        if (i == 0) {
          _mergedCourses.add(currentDayCourses[i]);
        } else {
          _mergedCourses.forEach((EventModel _model) {
            double _modelEndTime = _model.end.hour.toDouble() +
                (_model.end.minute.toDouble() / 60);
            double _courseStartTime = currentDayCourses[i].start.hour
                .toDouble() +
                (currentDayCourses[i].start.minute.toDouble() / 60);
            double diff = _modelEndTime - _courseStartTime;
            if (diff < 10 && diff > -10 &&
                currentDayCourses[i].courseId == _model.courseId &&
                currentDayCourses[i].courseName == _model.courseName &&
                currentDayCourses[i].remarks == _model.remarks &&
                currentDayCourses[i].eventType == _model.eventType) {
              notHave = false;
              _model.end = currentDayCourses[i].end;
            }
          });
          if (notHave) {
            _mergedCourses.add(currentDayCourses[i]);
          }
        }
      }
    }

    return _mergedCourses;
  }

  String returnText (String text) {
    if (text.length > 2) {
      return text.substring(0,2);
    } else {
      return text;
    }
  }

  List<EventModel> makeCourseEventModel (List<TodayCourse> todayCourses, List<MyCourse> myCourses) {
    List<EventModel> coursesEventModelList = [];

    if (todayCourses.length != 0 && todayCourses != null) {
      todayCourses.forEach((TodayCourse todayCourse) {
        myCourses.forEach((MyCourse myCourse) {
          myCourse.lectureCourse.forEach((String text) {
            if (text == todayCourse.course ||
                text == todayCourse.course.substring(0, 1) ||
                returnText(text) == todayCourse.course ||
                returnText(text) == todayCourse.course.substring(0, 1)) {
              if (text.length > 2) {
                coursesEventModelList.add(EventModel(start: todayCourse.start,
                    end: todayCourse.end,
                    isCourse: true,
                    courseId: myCourse.courseCode,
                    courseName: myCourse.courseName,
                    eventType: 'Lecture ${text.substring(2, text.length)}',
                    location: myCourse.lectureLocation,
                    instructors: myCourse.instructors,
                    credits: myCourse.credits,
                    preRequisite: myCourse.preRequisite));
              } else {
                coursesEventModelList.add(EventModel(start: todayCourse.start,
                    end: todayCourse.end,
                    isCourse: true,
                    courseId: myCourse.courseCode,
                    courseName: myCourse.courseName,
                    eventType: 'Lecture',
                    location: myCourse.lectureLocation,
                    instructors: myCourse.instructors,
                    credits: myCourse.credits,
                    preRequisite: myCourse.preRequisite));
              }
            }
          });
          myCourse.tutorialCourse.forEach((String text) {
            if (text == todayCourse.course ||
                text == todayCourse.course.substring(0, 1) ||
                returnText(text) == todayCourse.course ||
                returnText(text) == todayCourse.course.substring(0, 1)) {
              if (text.length > 2) {
                coursesEventModelList.add(EventModel(start: todayCourse.start,
                    end: todayCourse.end,
                    isCourse: true,
                    courseId: myCourse.courseCode,
                    courseName: myCourse.courseName,
                    eventType: 'Tutorial ${text.substring(2, text.length)}',
                    location: myCourse.tutorialLocation,
                    instructors: myCourse.instructors,
                    credits: myCourse.credits,
                    preRequisite: myCourse.preRequisite));
              } else {
                coursesEventModelList.add(EventModel(start: todayCourse.start,
                    end: todayCourse.end,
                    isCourse: true,
                    courseId: myCourse.courseCode,
                    courseName: myCourse.courseName,
                    eventType: 'Tutorial',
                    location: myCourse.tutorialLocation,
                    instructors: myCourse.instructors,
                    credits: myCourse.credits,
                    preRequisite: myCourse.preRequisite));
              }
            }
          });
          myCourse.labCourse.forEach((String text) {
            if (text == todayCourse.course ||
                text == todayCourse.course.substring(0, 1) ||
                returnText(text) == todayCourse.course ||
                returnText(text) == todayCourse.course.substring(0, 1)) {
              if (text.length > 2) {
                coursesEventModelList.add(EventModel(start: todayCourse.start,
                    end: todayCourse.end,
                    isCourse: true,
                    courseId: myCourse.courseCode,
                    courseName: myCourse.courseName,
                    eventType: 'Lab ${text.substring(2, text.length)}',
                    location: myCourse.labLocation,
                    instructors: myCourse.instructors,
                    credits: myCourse.credits,
                    preRequisite: myCourse.preRequisite));
              } else {
                coursesEventModelList.add(EventModel(start: todayCourse.start,
                    end: todayCourse.end,
                    isCourse: true,
                    courseId: myCourse.courseCode,
                    courseName: myCourse.courseName,
                    eventType: 'Lab',
                    location: myCourse.labLocation,
                    instructors: myCourse.instructors,
                    credits: myCourse.credits,
                    preRequisite: myCourse.preRequisite));
              }
            }
          });
        });
      });
    }

    return coursesEventModelList;
  }

  List listWithoutRepetitionEvent (List<calendar.Event> events) {
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

  List todayEventsList (List<calendar.Event> _events) {
    List<calendar.Event> todayEvents = [];
    _events.forEach((calendar.Event _event ) {
      if (_event.start != null ) {
        if (_event.start.dateTime != null) {
          DateTime today = DateTime.now();
          DateTime eventStartTime = _event.start.dateTime;
          if (eventStartTime.year == today.year &&
              eventStartTime.month == today.month &&
              eventStartTime.day == today.day) {
            todayEvents.add(_event);
          }
        }
      }
    });
    return todayEvents;
  }

  int partition(List<EventModel> list, int low, int high) {
    if (list == null || list.length == 0) return 0;
    DateTime pivot = list[high].start;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].start.isBefore(pivot) || list[j].start.isAtSameMomentAs(pivot)) {
        i++;
        swap(list, i, j);
      }
    }
    swap(list, i+1, high);
    return i+1;
  }

  void swap(List<EventModel> list, int i, int j) {
    EventModel temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  void quickSort(List<EventModel> list, int low, int high) {
    if (low < high) {
      int pi = partition(list, low, high);
      quickSort(list, low, pi-1);
      quickSort(list, pi+1, high);
    }
  }

  Widget body (BuildContext _context) {
    if (eventsList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Take rest!'),
            SizedBox(height: 8,),
            Text('No Classes or Events to attend Today.'),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColumnBuilder(
            mainAxisSize: MainAxisSize.min,
            itemBuilder: (context, index) {
              return eventsList[index].buildCard(_context);
            },
            itemCount: eventsList.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Schedule"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editevent');
            },
            icon: Icon(
              Icons.edit,
            ),
          )
        ],
      ),
      body: body(context),
    );
  }
}
