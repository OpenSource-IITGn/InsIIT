import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';

class EventModel {
  DateTime start;
  DateTime end;
  bool isCourse;
  String courseName;
  String courseId;
  String eventType;
  String remarks;
  EventModel(
      {this.start,
      this.end,
      this.isCourse,
      this.courseName,
      this.courseId,
      this.eventType,
      this.remarks});
  Widget buildCard() {
    return Card(
      child: Container(
        width: ScreenSize.size.width,
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text("08:00",
                      style: TextStyle(
                          color: Colors.black.withAlpha(200), fontSize: 17)),
                  SizedBox(
                    height: 8,
                  ),
                  Text("to",
                      style: TextStyle(
                          color: Colors.black.withAlpha(120), fontSize: 14)),
                  SizedBox(
                    height: 8,
                  ),
                  Text("09:00",
                      style: TextStyle(
                          color: Colors.black.withAlpha(200), fontSize: 17)),
                ]),
                verticalDivider(),
                Container(
                  width: ScreenSize.size.width * 0.65,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(this.courseId,
                            style: TextStyle(
                                color: Colors.black.withAlpha(120),
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(this.courseName,
                            style: TextStyle(
                                color: Colors.black.withAlpha(255),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(this.eventType + ' (${this.remarks})',
                            style: TextStyle(
                                color: Colors.black.withAlpha(200),
                                fontStyle: FontStyle.italic,
                                fontSize: 14)),
                      ]),
                ),
              ],
            )),
      ),
    );
  }
}

verticalDivider() {
  return Row(
    children: <Widget>[
      SizedBox(
        width: 16,
      ),
      Container(
        height: 50,
        width: 1,
        color: Colors.grey,
      ),
      SizedBox(
        width: 16,
      ),
    ],
  );
}
