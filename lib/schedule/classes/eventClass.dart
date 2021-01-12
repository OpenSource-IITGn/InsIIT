import 'package:flutter/material.dart';

class Event {
  DateTime startTime;
  DateTime endTime;
  String name;
  String host;
  String link;
  Event({
    this.startTime,
    this.endTime,
    this.name,
    this.host,
    this.link,
  });

  Widget buildEventCard() {
    return Card();
  }
}
