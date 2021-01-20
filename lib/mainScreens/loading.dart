import 'package:flutter/material.dart';

Widget loadScreen() {
  return Scaffold(
    body: Container(
      color: Color.fromARGB(255, 255, 137, 87),
      child: Center(
          child: Text(
        "Please wait...",
        style: TextStyle(color: Colors.white, fontSize: 20),
      )),
    ),
  );
}
