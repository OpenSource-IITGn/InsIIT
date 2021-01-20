import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
  pickDate(context, initialTime) async {
    TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initialTime.hour, minute: initialTime.minute));
    if (time != null) {
      return time;
    } else {
      return null;
    }
  }

  Widget buildEventCard(BuildContext context, {Function callBack}) {
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
            Navigator.pushNamed(context, '/eventdetail', arguments: {
              'event': this,
            });
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

  Widget buildEventDetails(BuildContext context, {Function callback}) {
    String startTimeString = formatDate(startTime, [HH, ':', nn]);
    String endTimeString = formatDate(endTime, [HH, ':', nn]);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textHeadingColor)),
          // Text(,
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(host,
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: theme.textHeadingColor)),
          SizedBox(
            height: 10,
          ),
          (link != null || link.length != 0)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: link.split(',').map((link) {
                    return GestureDetector(
                      onTap: () async {
                        if (await canLaunch(link)) {
                          await launch(link, forceSafariVC: false);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      child: Text(
                        (link == '-') ? "" : link,
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                )
              : Container(),
//          RichText(
//            text: TextSpan(
//              children: <TextSpan>[
//                TextSpan(
//                  text: 'Happens at ',
//                ),
//                TextSpan(
//                  text: location,
//                  style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: theme.textHeadingColor),
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 10,
//          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Between ',
                ),
                TextSpan(
                  text: startTimeString,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: endTimeString,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
