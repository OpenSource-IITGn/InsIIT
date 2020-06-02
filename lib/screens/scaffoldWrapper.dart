import 'package:flutter/material.dart';

class ScaffoldWrapper extends StatelessWidget {
  ScaffoldWrapper({this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: child,
    );
  }
}