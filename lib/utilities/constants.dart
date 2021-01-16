import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';

import 'package:intl/intl.dart';

bool darkMode = false;

final dateFormat = new DateFormat('dd-MM-yyyy hh:mm');
String baseUrl = "serene-reaches-30469.herokuapp.com";
String baseUrlTL = "tranquil-shore-67034.herokuapp.com";

// FirebaseUser firebaseUser;
// var currentUser;
final FirebaseAuth firebaseauth = FirebaseAuth.instance;

class ScreenSize {
  static Size size;
}

Map<int, String> weekDay = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday'
};

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
        color: theme.textHeadingColor.withAlpha(128),
      ),
      SizedBox(
        width: 16,
      ),
    ],
  );
}
