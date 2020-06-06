import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
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
  bool isSignedIn = false;
  // AuthService _auth = AuthService();

  Future checkWelcome() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String x = s.getString("welcome");
    print(x.runtimeType);
    if (x == null) {
      s.setString("welcome", "true");
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkWelcome().then((val) {
      if (val == true) {
        Navigator.pushNamed(context, '/onboarding');
      }
    });
    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print("Error message :" + gError);
    });
    gSignIn.signInSilently().then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error message :" + gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      print(gSignIn.currentUser.email);
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

  logoutUser() {
    gSignIn.signOut();
  }

  void authorize(asGuest) async {
    // Navigator.pop(context);
    if (asGuest) {
      await sheet.writeData([
        [
          DateTime.now().toString(),
          "Anon",
          "anonymous",
        ]
      ], 'logins!A:C');
    } else {
      await gSignIn.signIn();

      final authHeaders = await gSignIn.currentUser.authHeaders;
      final httpClient = GoogleHttpClient(authHeaders);

      var courseData = await ClassroomApi(httpClient).courses.list();
      courses.addAll(courseData.courses);
      coursesWithoutRepetition = listWithoutRepetitionCourse(courses);
      var eventData = await calendar.CalendarApi(httpClient).events.list('primary');
      events.addAll(eventData.items);
      eventsWithoutRepetition = listWithoutRepetitionEvent(events);

      final GoogleSignInAuthentication googleAuth =
      await gSignIn.currentUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await firebaseauth.signInWithCredential(credential)).user;
      await sheet.writeData([
        [
          DateTime.now().toString(),
          gSignIn.currentUser.displayName,
          gSignIn.currentUser.email,
        ]
      ], 'logins!A:C');
    }
    Navigator.pop(context);
    Navigator.pushNamed(context, '/menuBarBase');
  }

  List listWithoutRepetitionCourse (List<Course> courses) {
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
                Image.asset('assets/images/homepage.png'),
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
                    color: primaryColor,
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
