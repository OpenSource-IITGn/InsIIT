import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eventClass.dart';

class Exam extends Event {
  String code;
  String location;
  Exam({
    name,
    startTime,
    endTime,
    link,
    currentlyRunning,
    this.location,
    this.code,
  }) : super(
            name: name,
            startTime: startTime,
            link: link,
            endTime: endTime,
            currentlyRunning: currentlyRunning);

  factory Exam.fromSheetRow(List row) {
    var date = row[0].split('/');
    var temp = row[1].replaceAll(' ', '');
    temp = temp.split('-');

    var starttime = temp[0].split(':');
    var endtime = temp[1].split(':');
    DateTime startTime = DateTime(int.parse(date[2]), int.parse(date[0]),
        int.parse(date[1]), int.parse(starttime[0]), int.parse(starttime[1]));
    DateTime endTime = DateTime(int.parse(date[2]), int.parse(date[0]),
        int.parse(date[1]), int.parse(endtime[0]), int.parse(endtime[1]));
    return Exam(
        name: row[3],
        startTime: startTime,
        endTime: endTime,
        code: row[2].replaceAll(' ', ''));
  }

  @override
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
                    Text(startTimeString,
                        style: TextStyle(color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to",
                        style: TextStyle(
                            fontSize: 14, color: theme.textHeadingColor)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(endTimeString,
                        style: TextStyle(color: theme.textHeadingColor)),
                  ]),
                  verticalDivider(),
                  // descriptionWidget(),
                  Container(
                    //width: ScreenSize.size.width * 0.55,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("$code",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: theme.textSubheadingColor)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.textHeadingColor)),
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
                              Text('Exam',
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

  @override
  Widget buildEventDetails(BuildContext context, {Function callback}) {
    String startTimeString = formatDate(startTime, [HH, ':', nn]);
    String endTimeString = formatDate(endTime, [HH, ':', nn]);
    String dateString =
        formatDate(startTime, [DD, ' (', d, ' / ', m, ' / ', yy, ')']);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
                "${code.substring(0, 2)} ${code.substring(2)} | ${name}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textHeadingColor)),
          ),
          ListTile(
              title: Text('Exam',
                  style: TextStyle(
                    color: theme.textHeadingColor,
                    fontWeight: FontWeight.bold,
                  ))),
          ListTile(
              trailing: Icon(Icons.edit, color: theme.iconColor),
              onTap: () async {
                await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101))
                    .then((time) {
                  if (time != null) {
                    startTime = DateTime(time.year, time.month, time.day,
                        startTime.hour, startTime.minute);
                    endTime = DateTime(time.year, time.month, time.day,
                        endTime.hour, endTime.minute);
                    callback();
                  }
                });
              },
              title: Text('Date         : ${dateString}',
                  style: TextStyle(
                    color: theme.textHeadingColor,
                  ))),
          ListTile(
            title: Text("Start         : ${startTimeString}",
                style: TextStyle(
                  color: theme.textHeadingColor,
                )),
            trailing: Icon(Icons.edit, color: theme.iconColor),
            onTap: () {
              pickDate(context, startTime).then((time) {
                if (time != null) {
                  startTime = DateTime(startTime.year, startTime.month,
                      startTime.day, time.hour, time.minute);
                  callback();
                }
              });
            },
          ),
          ListTile(
            title: Text("End           : ${endTimeString} ",
                style: TextStyle(
                  color: theme.textHeadingColor,
                )),
            trailing: Icon(Icons.edit, color: theme.iconColor),
            onTap: () {
              pickDate(context, endTime).then((time) {
                if (time != null) {
                  endTime = DateTime(endTime.year, endTime.month, endTime.day,
                      time.hour, time.minute);
                  callback();
                }
              });
            },
          ),
          (link != null && link.length != 0)
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
        ],
      ),
    );
  }
}
