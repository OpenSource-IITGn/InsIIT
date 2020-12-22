import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';

import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScrollController _scrollController;
  int _index = 0;

  Widget body(BuildContext _context, int dayIndex) {
    if (eventsList == null || eventsList.length == 0 || eventsList[dayIndex].length == 0) {
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
            Text('No classes or events to attend today.',
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
          controller: (dayIndex == DateTime.now().weekday - 1)?_scrollController:null,
          // mainAxisSize: MainAxisSize.min,
          itemBuilder: (context, index) {
            return eventsList[dayIndex][index].buildCard(_context);
          },
          itemCount: eventsList[dayIndex].length,
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
    eventsList[DateTime.now().weekday - 1].asMap().forEach((int index, EventModel event) {
      if (!getIndex && event.end.isAfter(_currentTime)) {
        _index = index;
        getIndex = true;
        event.currentlyRunning = true;
      }
    });

    return DefaultTabController(
      initialIndex: DateTime.now().weekday - 1,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Your Schedule',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editevent').then((value) => setState((){}));
              },
              icon: Icon(Icons.edit, color: Colors.black),
            )
          ],
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              indicatorColor: primaryColor,
              // unselectedLabelStyle:
              //     TextStyle(color: Colors.black.withOpacity(0.3)),
              tabs: <Widget>[
                Tab(text: 'Monday'),
                Tab(text: 'Tuesday'),
                Tab(
                  text: 'Wednesday',
                ),
                Tab(text: 'Thursday'),
                Tab(text: 'Friday'),
                Tab(
                  text: 'Saturday',
                ),
                Tab(
                  text: 'Sunday',
                ),
              ],
            ),
            preferredSize: Size.fromHeight(50.0),
          ),
        ),
        body: TabBarView(
          children: [0, 1, 2, 3, 4, 5, 6].map((e) {
            return body(context, e);
          }).toList(),
        ),
      ),
    );
  }
}
