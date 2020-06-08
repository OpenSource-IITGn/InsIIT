import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

Color secondaryColor = Color.fromRGBO(63, 99, 247, 0.7);
Color primaryColor = Color.fromRGBO(63, 99, 247, 1);
// Color primaryColor = Color.fromRGBO(0, 0, 0, 1);
// Color secondaryColor = Color.fromRGBO(0, 0, 0, 0.5);
Color secondaryTextColor = Colors.black.withAlpha(150);
final dateFormat = new DateFormat('dd-MM-yyyy hh:mm');
String baseUrl = "serene-reaches-30469.herokuapp.com";
String baseUrlTL = "tranquil-shore-67034.herokuapp.com";
final GoogleSignIn gSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/classroom.courses.readonly',
    'https://www.googleapis.com/auth/calendar.events.readonly',
  ],
);
FirebaseUser firebaseUser;
final FirebaseAuth firebaseauth = FirebaseAuth.instance ;
class ScreenSize {
  static Size size;
}
