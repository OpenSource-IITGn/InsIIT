import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScrollController _scrollController;
  int _index = 0;

  Widget body(BuildContext _context, int day) {
    if (dataContainer.schedule.schedule == null ||
        dataContainer.schedule.schedule.length == 0 ||
        dataContainer.schedule.schedule[day].length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/freetime.png'),
            SizedBox(
              height: 40,
            ),
            Text(
              'Take rest!',
              style: TextStyle(fontSize: 18, color: theme.textHeadingColor),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'No classes or events to attend today.',
              style: TextStyle(fontSize: 18, color: theme.textSubheadingColor),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          controller:
              (day == DateTime.now().weekday) ? _scrollController : null,
          // mainAxisSize: MainAxisSize.min,
          itemBuilder: (context, index) {
            dynamic event = dataContainer.schedule.schedule[day][index];
            return event.buildEventCard(_context, callBack: () {
              setState(() {});
            });
          },
          itemCount: dataContainer.schedule.schedule[day].length,
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
    dataContainer.schedule.buildData();
    bool getIndex = false;
    DateTime _currentTime = DateTime.now();
    dataContainer.schedule.schedule[DateTime.now().weekday]
        .asMap()
        .forEach((int index, dynamic event) {
      if (!getIndex && event.endTime.isAfter(_currentTime)) {
        _index = index;
        getIndex = true;
        event.currentlyRunning = true;
      }
    });

    return DefaultTabController(
      initialIndex: DateTime.now().weekday - 1,
      length: 7,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text('Your Schedule',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editevent')
                    .then((value) => setState(() {}));
              },
              icon: Icon(Icons.edit, color: theme.iconColor),
            )
          ],
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,

              unselectedLabelColor: theme.textHeadingColor.withOpacity(0.3),
              indicatorColor: theme.indicatorColor,
              labelColor: theme.textHeadingColor,
              // unselectedLabelStyle:
              //     TextStyle(color: Colors.black.withOpacity(0.3)),
              tabs: <Widget>[
                Tab(text: 'Monday'),
                Tab(text: 'Tuesday'),
                Tab(text: 'Wednesday'),
                Tab(text: 'Thursday'),
                Tab(text: 'Friday'),
                Tab(text: 'Saturday'),
                Tab(text: 'Sunday'),
              ],
            ),
            preferredSize: Size.fromHeight(50.0),
          ),
        ),
        body: TabBarView(
          children: [1, 2, 3, 4, 5, 6, 7].map((e) => body(context, e)).toList(),
        ),
      ),
    );
  }
}
