import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:instiapp/utilities/measureSize.dart';
import 'package:instiapp/utilities/signInMethods.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Course> courses = [];
List<Course> coursesWithoutRepetition;
List<calendar.Event> events = [];
List<calendar.Event> eventsWithoutRepetition;

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

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loading = false;
  ValueNotifier<bool> isSignedIn = ValueNotifier(false);
  var user;
  Size buttonSize = Size(200, 0);

  Future checkWelcome() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String x = s.getString("welcome");
    if (x == null) {
      s.setString("welcome", "true");
      return true;
    } else {
      return false;
    }
  }

  Future getEventsCached() async {
    var file = await _localFile('events');
    bool exists = await file.exists();
    if (exists) {
      print("EVENTS CACHED PREVIOUSLY");
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
      print("EVENTS NOT CACHED PREVIOUSLY");
    }

    return false;
  }

  Future storeEventsCached() async {
    var file = await _localFile('events');
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
    print("WROTE EVENTS TO CACHE");
    return true;
  }

  Future getEventsOnline(httpClient) async {
    var eventData = await calendar.CalendarApi(httpClient).events.list('primary');
    events = [];
    events.addAll(eventData.items);
    eventsWithoutRepetition = listWithoutRepetitionEvent(events);
  }

  Future getCoursesCached() async {
    var file = await _localFile('courses');
    bool exists = await file.exists();
    if (exists) {
      print("Courses CACHED PREVIOUSLY");
      await file.open();
      String events = await file.readAsString();
      List<Course> coursesList = [];
      var json = jsonDecode(events);
      json['key'].forEach((eventJson) {
        Course x = Course.fromJson(eventJson);
        coursesList.add(x);
      });
      return coursesList;
    } else {
      print("Courses NOT CACHED PREVIOUSLY");
    }

    return false;
  }

  Future storeCoursesCached() async {
    var file = await _localFile('courses');
    bool exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    await file.create();
    await file.open();
    List<Map<String, dynamic>> courseList = [];
    courses.forEach((element) {
      courseList.add(element.toJson());
    });
    Map<String, dynamic> list = {'key': courseList};
    await file.writeAsString(jsonEncode(list));
    print("WROTE Courses TO CACHE");
    return true;
  }

  Future getCoursesOnline(httpClient) async {
    courses = [];
    var courseData = await ClassroomApi(httpClient).courses.list();
    courses.addAll(courseData.courses);
    coursesWithoutRepetition = listWithoutRepetitionCourse(courses);
  }

  Future<File> _localFile(String range) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = tempPath + range + '.csv';
    return File(filename);
  }

  Future reloadEventsAndCourses() async {
    final authHeaders = await gSignIn.currentUser.authHeaders;
    final httpClient = GoogleHttpClient(authHeaders);
    await getEventsCached().then((values) async {
      if (values != false) {
        print("Cached Events");
        events = values;
        eventsWithoutRepetition = listWithoutRepetitionEvent(events);
      } else {
        print("Not cached events");
        await getEventsOnline(httpClient).then((value) {
          storeEventsCached();
        });
      }
    });
    getEventsOnline(httpClient).then((value) {
      storeEventsCached();
    });

    await getCoursesCached().then((values) async {
      if (values != false) {
        courses = values;
        coursesWithoutRepetition = listWithoutRepetitionCourse(courses);
      } else {
        await getCoursesOnline(httpClient).then((value) {
          storeCoursesCached();
        });
      }
    });
    getCoursesOnline(httpClient).then((value) {
      storeCoursesCached();
    });
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

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      if (user.displayName == null || user.displayName.length == 0) {
        currentUser = null;
      } else {
        currentUser = {
          "given_name": user.displayName,
          "email": user.email,
          "picture": user.photoURL,
          'uid': user.uid
        };
        Future.delayed(const Duration(milliseconds: 50)).then((value) {
          Navigator.pushReplacementNamed(context, '/menuBarBase');
        });
      }
    }
    checkWelcome().then((val) {
      if (val == true) {
        Navigator.pushNamed(context, '/onboarding');
      }
    });
  }

  void authorize(asGuest) async {
    if (asGuest) {
      currentUser = null;
      FirebaseAuth.instance.signInAnonymously();
      print("Logging in as guest");
      Navigator.pushReplacementNamed(context, '/menuBarBase');
    } else {
      print("Started GSIGN IN Method");
      await signInWithGoogle().then((user) async {
        if (user != null) {
          currentUser = user.additionalUserInfo.profile;
          await reloadEventsAndCourses().then((s) {});
          Navigator.pushReplacementNamed(context, '/menuBarBase');
        }
      });
      print("AUTHORIZED");
    }
  }

  var key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: key,
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.asset('assets/images/homepageGif.gif')),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text("InsIIT",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 50)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Text("All things IITGN",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black.withAlpha(150),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    Column(children: [
                      MeasureSize(
                        onChange: (Size size) {
                          buttonSize = size;
                          setState(() {});
                        },
                        child: FlatButton(
                          onPressed: () => authorize(false),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              child: Text(
                                "Login with IITGN ID (Google)",
                                style: TextStyle(
                                  color: Colors.white.withAlpha(230),
                                ),
                              ),
                            ),
                          ),
                          color: Color.fromRGBO(228, 110, 96, 1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Colors.grey.withAlpha(230),
                          ),
                        ),
                      ),
                      Container(
                        width: buttonSize.width,
                        child: FlatButton(
                          onPressed: () => authorize(true),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                              side: BorderSide(
                                color: Colors.grey.withAlpha(50),
                              )),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
                            child: Container(
                              child: Text(
                                "Login as Guest",
                                style: TextStyle(
                                  color: Colors.grey.withAlpha(230),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
