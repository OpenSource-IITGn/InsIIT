import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';

Widget loadScreen() {
  return Scaffold(
    body: Container(
      color: Color.fromARGB(255, 255, 137, 87),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(
          //     width: 200, child: Image.asset('assets/images/insiiticon.png')),
          Text(
            "InsIIT",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 80),
          ),
          SizedBox(height: 10),
          Text(
            "A HackRush Project",
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.italic, fontSize: 20),
          ),
          SizedBox(height: 40),
          Text(
            "Please wait ... ",
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.italic, fontSize: 20),
          ),
          // SizedBox(height: 10),
          // Container(
          //     width: 200,
          //     child: Image.asset(
          //       'assets/images/hackrush.png',
          //     )),
        ],
      )),
    ),
  );
}
