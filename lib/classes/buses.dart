import 'package:flutter/cupertino.dart';

class Buses {
  String destination;
  String time;
  String origin;
  Image image;
  int hour;
  int minute;

  Buses(
      {this.destination,
      this.origin,
      this.time,
      this.image,
      this.hour,
      this.minute});
}
