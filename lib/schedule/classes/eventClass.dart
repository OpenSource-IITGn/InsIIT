import 'dart:math';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

class Event {
  DateTime startTime;
  DateTime endTime;
  String name;
  String host;
  Color color;
  String link;
  bool currentlyRunning = false;
  Event(
      {this.startTime,
      this.endTime,
      this.name,
      this.color,
      this.host,
      this.link,
      this.currentlyRunning});

  // void setColor(index) {
  //   double alpha = 1 - index / 100;
  //   index = index % Colors.primaries.length;
  //   color = Colors.primaries[index].withOpacity(alpha);
  // }

  Widget buildEventCard(context) {
    String startTimeString = formatDate(startTime, [HH, ':', nn]);
    String endTimeString = formatDate(endTime, [HH, ':', nn]);
    bool ongoing =
        DateTime.now().isBefore(endTime) && startTime.isBefore(DateTime.now());

    return Card(
      color: theme.cardBgColor,
      child: Container(
        width: ScreenSize.size.width,
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed('/eventdetail', arguments: {
            //   'eventModel': this,
            // });
          },
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(startTimeString),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to",
                        style: TextStyle(
                            fontSize: 14, color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(endTimeString),
                  ]),
                  verticalDivider(),
                  // descriptionWidget(),
                  Container(
                    //width: ScreenSize.size.width * 0.55,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: theme.textSubheadingColor)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Flexible(
                            child: Text(host,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.textHeadingColor)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // (this.links != null || this.links.length != 0)
                          //     ? Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: this.links.map((link) {
                          //           return GestureDetector(
                          //             onTap: () async {
                          //               if (await canLaunch(link)) {
                          //                 await launch(link, forceSafariVC: false);
                          //               } else {
                          //                 throw 'Could not launch $link';
                          //               }
                          //             },
                          //             child: Text(
                          //               link,
                          //               style: TextStyle(color: Colors.blue, fontSize: 15),
                          //             ),
                          //           );
                          //         }).toList(),
                          //       )
                          //     : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(host,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      color: theme.textHeadingColor)),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ]),
                  ),
                  (ongoing == true)
                      ? Icon(
                          Icons.adjust,
                          color: Colors.green,
                        )
                      : Container(),
                ],
              )),
        ),
      ),
    );
  }
}
