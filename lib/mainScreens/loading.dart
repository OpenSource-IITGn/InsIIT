//TODO: ADD FLARE SPLASH SCREEN BETWEEN LOGIN AND HOMEPAGE

import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';
import 'dart:math' as math;

Widget loadScreen() {
  // Color color = secondaryColor;
  return Scaffold(
    body: Container(
      // height: ScreenSize.size.height,
      // width: ScreenSize.size.width,
      // color: color,
      child: Center(
          child: Text(
        "Please wait...",
        style: TextStyle(color: Colors.white, fontSize: 20),
      )),
    ),
  );
}
