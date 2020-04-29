//TODO: ADD FLARE SPLASH SCREEN BETWEEN LOGIN AND HOMEPAGE.s

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instiapp/utilities/constants.dart';

Widget loadScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('InstiApp'),
        centerTitle: true,
      ),
      body: Center(
        child: SpinKitChasingDots(
          color: primaryColor,
          size: 50.0,
        ),
      ),
    );
  }