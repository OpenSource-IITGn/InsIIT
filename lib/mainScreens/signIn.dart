import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/mainScreens/loading.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/globalClasses/user.dart' as userModel;
import 'package:instiapp/utilities/measureSize.dart';
import 'package:instiapp/utilities/signInMethods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instiapp/data/dataContainer.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  ValueNotifier<bool> isSignedIn = ValueNotifier(false);
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

  @override
  void initState() {
    super.initState();
    print(dataContainer.fireBase.user);
    navigateToHome();
    checkWelcome().then((val) {
      if (val == true) {
        Navigator.pushNamed(context, '/onboarding');
      }
    });
  }

  void navigateToHome () {
    if (dataContainer.fireBase.user != null) {
      if (dataContainer.fireBase.user.displayName == null || dataContainer.fireBase.user.displayName.length == 0) {
        currentUser = null;
      } else {
        currentUser = userModel.User(
            name: dataContainer.fireBase.user.displayName,
            imageUrl: dataContainer.fireBase.user.photoURL,
            email: dataContainer.fireBase.user.email,
            uid: dataContainer.fireBase.user.uid);

        if (dataContainer.schedule.eventsReady) {
          Navigator.pushReplacementNamed(context, '/menuBarBase');
        } else {
          dataContainer.schedule.reloadEventsAndCourses().then((s) {
            Navigator.pushReplacementNamed(context, '/menuBarBase');
          });
        }
      }
    }
  }

  void authorize(asGuest) async {
    if (asGuest) {
      currentUser = null;
      FirebaseAuth.instance.signInAnonymously();
      // print("Logging in as guest");
      Navigator.pushReplacementNamed(context, '/menuBarBase');
    } else {
      // print("Started GSIGN IN Method");
      await signInWithGoogle().then((user) {
        if (user != null) {
          var temp = user.additionalUserInfo.profile;
          currentUser = userModel.User(
              name: temp['given_name'],
              imageUrl: temp['picture'],
              email: temp['email'],
              uid: temp['uid']);
        }
      });
      // print("AUTHORIZED");
      await dataContainer.schedule.reloadEventsAndCourses().then((s) {});
      Navigator.pushReplacementNamed(context, '/menuBarBase');
    }
  }

  var key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (!dataContainer.fireBase.initialized) {
      setState(() {
        dataContainer.fireBase.initialize(navigateToHome);
      });
    }
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.4,
                          child: Image.asset(
                              'assets/images/homepageGif.gif')),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 8, 16, 8),
                              child: Text("InsIIT",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 0, 16, 8),
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
                          padding: const EdgeInsets.fromLTRB(
                              16.0, 8, 16, 8),
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
                                borderRadius: new BorderRadius.circular(
                                    40.0),
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
