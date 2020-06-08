import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Course> courses = [];
List<Course> coursesWithoutRepetition;
List<calendar.Event> events = [];
List<calendar.Event> eventsWithoutRepetition;
bool guest = false;

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

final FirebaseAuth _auth = FirebaseAuth.instance;

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

logoutUser() async {
  gSignIn.signOut();
  FirebaseAuth.instance.signOut();
  var file = await _localFile('events');
  bool exists = await file.exists();
  if (exists) {
    await file.delete();
  }
  file = await _localFile('courses');
  exists = await file.exists();
  if (exists) {
    await file.delete();
  }
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
      events = values;
      eventsWithoutRepetition = listWithoutRepetitionEvent(events);
    } else {
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

class _SignInPageState extends State<SignInPage> {
  bool loading = false;
  bool isSignedIn = false;
  // AuthService _auth = AuthService();

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

  Future checkSignIn() async {
    firebaseUser = await _auth.currentUser();
    return firebaseUser;
  }

  @override
  void initState() {
    super.initState();
    checkWelcome().then((val) {
      if (val == true) {
        Navigator.pushNamed(context, '/onboarding');
      }
    });
    checkSignIn().then((value) async {
      try {
        print("Sign in silent");
        await gSignIn.signInSilently().then((gSignInAccount) {
          print('Sign in successful');
          controlSignIn(gSignInAccount);
        }).catchError((gError) {
          print("Error message :" + gError);
        });
      } catch (e) {
        print('Error:' + e);
      }
      try {
        print("on current user changed");
        gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
          controlSignIn(gSigninAccount);
        }, onError: (gError) {
          print("Error message :" + gError);
        });
      } catch (e) {
        print('Error:' + e);
      }
    });

    // signInWithGoogle().then((value) => print(value));
  }

  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount googleSignInAccount = await gSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );
  //   final AuthResult authResult = await _auth.signInWithCredential(credential);
  //   final FirebaseUser user = authResult.user;
  //   assert(!user.isAnonymous);
  //   assert(await user.getIdToken() != null);
  //   final FirebaseUser currentUser = await _auth.currentUser();
  //   assert(user.uid == currentUser.uid);
  //   return 'signInWithGoogle succeeded: $user';
  // }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    print('Checking for correct account');
    print(signInAccount);
    if (signInAccount != null) {
      print('actually signed in');
      if (gSignIn.currentUser.email.split('@')[1] != 'iitgn.ac.in') {
        await logoutUser();
        key.currentState.hideCurrentSnackBar();
        key.currentState.showSnackBar(
            SnackBar(content: Text("Please sign in with your IITGN account!")));
      } else {
        authorize(false);
        setState(() {
          isSignedIn = true;
        });
      }
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  void authorize(asGuest) async {
    // Navigator.pop(context);
    if (asGuest) {
      guest = true;
      sheet.writeData([
        [
          DateTime.now().toString(),
          "Anon",
          "anonymous",
        ]
      ], 'logins!A:C');
    } else {
      print("Awaiting gsignin sign in");
      await gSignIn.signIn();
      print(" gsignin signed in");

      await reloadEventsAndCourses().then((s) {});

      try {
        final GoogleSignInAuthentication googleAuth =
            await gSignIn.currentUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        firebaseUser =
            (await firebaseauth.signInWithCredential(credential)).user;
      } catch (e) {}

      // sheet.writeData([
      //   [
      //     DateTime.now().toString(),
      //     gSignIn.currentUser.displayName,
      //     gSignIn.currentUser.email,
      //   ]
      // ], 'logins!A:C');
    }
    Navigator.pop(key.currentContext);
    Navigator.pushNamed(context, '/menuBarBase');
  }

  var key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: key,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/homepageGif.gif'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text("All things IITGN",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
                ),
                SizedBox(height: 100),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  // height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: FlatButton(
                    onPressed: () => authorize(false),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Text(
                          "Login with IITGN ID(Google)",
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
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: FlatButton(
                    onPressed: () => authorize(true),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(40.0),
                        side: BorderSide(
                          color: Colors.grey.withAlpha(50),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
