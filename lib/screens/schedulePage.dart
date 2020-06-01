import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/screens/homePage.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  ScrollController _scrollController;
  int _index = 0;

  Widget body (BuildContext _context) {
    if (eventsList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Take rest!'),
            SizedBox(height: 8,),
            Text('No Classes or Events to attend Today.'),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ColumnBuilder(
          controller: _scrollController,
          mainAxisSize: MainAxisSize.min,
          itemBuilder: (context, index) {
            return eventsList[index].buildCard(_context);
          },
          itemCount: eventsList.length,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _scrollController.animateTo(_index*100.toDouble(), duration: new Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool getIndex = false;
    DateTime _currentTime = DateTime.now();
    eventsList.asMap().forEach((int index, EventModel event) {
      if (!getIndex && event.end.isAfter(_currentTime)) {
        _index = index;
        getIndex = true;
        event.currentlyRunning = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Schedule"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editevent');
            },
            icon: Icon(
              Icons.edit,
            ),
          )
        ],
      ),
      body: body(context),
    );
  }
}
