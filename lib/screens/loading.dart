//TODO: ADD FLARE SPLASH SCREEN BETWEEN LOGIN AND HOMEPAGE.s

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instiapp/utilities/constants.dart';
import 'dart:math' as math;

Widget loadScreen() {
  Color color = Colors.blue;
  return Scaffold(
    body: AnimatedContainer(
      duration: Duration(milliseconds: 500),
      onEnd: () {
        color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
      },
      height: ScreenSize.size.height,
      width: ScreenSize.size.width,
      color: color,
      child: Text("Please wait..."),
    ),
  );
}
