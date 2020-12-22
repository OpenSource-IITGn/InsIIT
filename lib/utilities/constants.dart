import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

bool darkMode = false;

Color backgroundColor = Colors.white.withAlpha(252);
Color backgroundColorDarkMode = Color.fromRGBO(18, 18, 18, 1);

Color navBar = Colors.white;
Color navBarDarkMode = Color.fromRGBO(97, 97, 97, 0.1);

Color primaryTextColor = Colors.black;
Color primaryTextColorDarkMode = Colors.white;

Color primaryTextColorReverse = Colors.white;
Color primaryTextColorReverseDarkMode = Colors.black;

Color secondaryTextColor = Colors.black.withAlpha(150);
Color secondaryTextColorDarkMode = Colors.white30.withOpacity(1);

Color secondaryColor = Color.fromRGBO(63, 99, 247, 0.7);
Color primaryColor = Color.fromRGBO(63, 99, 247, 1);
// Color primaryColor = Color.fromRGBO(0, 0, 0, 1);
// Color secondaryColor = Color.fromRGBO(0, 0, 0, 0.5);
//Color secondaryTextColor = Colors.black.withAlpha(150);
final dateFormat = new DateFormat('dd-MM-yyyy hh:mm');
String baseUrl = "serene-reaches-30469.herokuapp.com";
String baseUrlTL = "tranquil-shore-67034.herokuapp.com";
 final GoogleSignIn gSignIn = GoogleSignIn(
   hostedDomain: 'iitgn.ac.in',
   scopes: <String>[
     'email',
     //'https://www.googleapis.com/auth/classroom.courses.readonly',
     'https://www.googleapis.com/auth/calendar.events.readonly',
   ],
 );
// FirebaseUser firebaseUser;
var currentUser;
final FirebaseAuth firebaseauth = FirebaseAuth.instance;

class ScreenSize {
  static Size size;
}

verticalDivider({double height}) {
  if (height == null) {
    height = 50.0;
  }
  return Row(
    children: <Widget>[
      SizedBox(
        width: 16,
      ),
      Container(
        height: height,
        width: 1,
        color: Colors.grey,
      ),
      SizedBox(
        width: 16,
      ),
    ],
  );
}
