import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:instiapp/utilities/measureSize.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

logoutUser() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser =
        await GoogleSignIn(hostedDomain: 'iitgn.ac.in').signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentUser = {
        "given_name": user.displayName,
        "email": user.email,
        "picture": user.photoURL
      };
      Future.delayed(const Duration(milliseconds: 50)).then((value) {
        Navigator.pushReplacementNamed(context, '/menuBarBase');
      });
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
      Navigator.pop(key.currentContext);
      Navigator.pushNamed(context, '/menuBarBase');
    } else {
      print("Waiting for GSIGN IN");
      await signInWithGoogle().then((user) {
        if (user != null) {
          currentUser = user.additionalUserInfo.profile;

          Navigator.pop(key.currentContext);
          Navigator.pushNamed(context, '/menuBarBase');
        }
      });
      print("Successfully AUTHORIZED");
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
