import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';

import 'package:instiapp/screens/homePage.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScrollController _scrollController;
  int _index = 0;

  Widget body(BuildContext _context) {
    if (eventsList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                'assets/images/freetime.png'
            ),
            SizedBox(
              height: 40,
            ),
            Text('Take rest!',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),),
            SizedBox(
              height: 8,
            ),
            Text('No Classes or Events to attend Today.',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          controller: _scrollController,
          // mainAxisSize: MainAxisSize.min,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_index * 100.toDouble(),
            duration: new Duration(milliseconds: 500), curve: Curves.ease);
      }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Your Schedule',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editevent').then((value) => setState((){}));
            },
            icon: Icon(Icons.edit, color: Colors.black),
          )
        ],
      ),
      body: body(context),
    );
  }
}
