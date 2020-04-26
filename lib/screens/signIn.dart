import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instiapp/auth.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/googleSheets.dart';
class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loading = false;
  bool isSignedIn = false;
  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
  // AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
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
