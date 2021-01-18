import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/data/dataContainer.dart';

class EventDetail extends StatefulWidget {
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Map eventModelData = {};
//  List<Widget> attendance;
//
//  List<Widget> attendanceManager(Map<DateTime, String> attendanceManager) {
//    List<Widget> listTiles = [];
//    attendanceManager.forEach((DateTime time, String attendance) {
//      listTiles.add(ListTile(
//        title: Text('${time.day} /${time.month} /${time.year}'),
//        trailing: Text(attendance),
//      ));
//    });
//    return listTiles;
//  }

  @override
  Widget build(BuildContext context) {
    eventModelData = ModalRoute.of(context).settings.arguments;
    dynamic event = eventModelData['event'];
//    if (event.isCourse) {
//      attendance = attendanceManager(event.attendanceManager);
//    }
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: theme.iconColor),
            onPressed: () {
              dataContainer.schedule.storeAllData();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Details',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
      ),
      body: SingleChildScrollView(
        child: event.buildEventDetails(context, callback: () {
          setState(() {});
        }),
      ),
    );
  }
}
