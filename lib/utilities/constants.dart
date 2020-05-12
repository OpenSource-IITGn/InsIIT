import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Color secondaryColor = Color.fromRGBO(44,50,190,1);
Color primaryColor = Color.fromRGBO(65,97,255,1);
Color secondaryTextColor = Colors.black.withAlpha(150);
final GoogleSignIn gSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/classroom.courses.readonly',
    'https://www.googleapis.com/auth/calendar.events.readonly',
  ],
);
final FirebaseAuth firebaseauth = FirebaseAuth.instance ;
class ScreenSize {
  static Size size;
}
