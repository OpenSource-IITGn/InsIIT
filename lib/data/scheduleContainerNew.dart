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

class ScheduleContainerActual {

  List<List<Course>>
      allCourses; //this is fetched only when new courses are going to be added in the addcourses page

  List<List<Course>> enrolledCourses;
  List<List<Event>> events;
  List<List<Exam>> exams; //this should be based on enrolledCourses

  static Map<String, List<DateTime>> slots = {
    'A1': [
      DateTime(2021, 1, 1, 8, 5),
      DateTime(2021, 1, 1, 9, 5)
    ] //8:05 to 9:05

    // GET THIS FROM THE SHEET AND STORE HERE LIKE THIS
  };

  static List<DateTime>  getTimeFromSlot(String slot) {
    return slots[slot];
  }

  void getData() {
    // check if there is a cached file that has enrolledCourses
    // load all courses from sheets
    // load events from calendar api
    reloadEvents();
    // load exams from sheets
  }

  //COURSES
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

  Future loadUserEnrolledCoursesData() async {
    getCachedData('userEnrolledCourses').then((data) { //Have defined getCachedData and storeCachedData functions in GlobalFunctions
      enrolledCourses = data;
      print(enrolledCourses);
    });
  }

  //EVENTS
  Future reloadEvents() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      events = [[],[],[],[],[],[],[]];
    } else {
      // await dataContainer.auth.gSignIn.signIn();
      //dataContainer.auth.gSignIn.signInSilently().then((value) async {
        final authHeaders =
        await dataContainer.auth.gSignIn.currentUser.authHeaders;
        final httpClient = GoogleHttpClient(authHeaders);
        getEventsOnline(httpClient);
      //});
    }
  }

  Future getEventsOnline(httpClient) async {
    var eventData =
    await calendar.CalendarApi(httpClient).events.list('primary');
    List<calendar.Event> tempEvents = [];
    tempEvents.addAll(eventData.items);
    makeListWithoutRepetitionEvent(tempEvents);
  }

  void makeListWithoutRepetitionEvent(List<calendar.Event> tempEvents) {
    List<calendar.Event> withoutRepeat = [];
    events = [[],[],[],[],[],[],[]];
    int day = DateTime.now().weekday;
    tempEvents.forEach((calendar.Event event) {
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

    withoutRepeat.forEach((calendar.Event event) {
      events[day - 1].add(Event(
        startTime: event.start.dateTime.toLocal(),
        endTime: event.end.dateTime.toLocal(),
        name: event.description,
        host: event.creator.displayName,
        link: event.htmlLink //TODO: Have to check how to obtain link from calendar.event object
      ));
    });
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
