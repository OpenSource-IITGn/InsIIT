import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:instiapp/utilities/constants.dart';



class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isSignedIn = false;

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
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
    print("SIGNED IN: $isSignedIn");
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
