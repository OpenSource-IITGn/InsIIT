import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
