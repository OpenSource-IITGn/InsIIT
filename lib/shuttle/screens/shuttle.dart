import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instiapp/shuttle/classes/buses.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';

class Shuttle extends StatefulWidget {
  @override
  _ShuttleState createState() => _ShuttleState();
}

class _ShuttleState extends State<Shuttle>
    with
        TickerProviderStateMixin<Shuttle>,
        AutomaticKeepAliveClientMixin<Shuttle> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  ScrollController _scrollController;
  int _index = 0;
  int hour;
  int minute;
  DateTime _busTime;
  String origin = 'Origin';
  String destination = 'Destination';
  List<String> places = [
    'Palaj',
    'Visat Circle',
    'Kudasan',
    'Infocity',
    'RakshaShakti',
    'Pathikashram'
  ];

  void reminder(buses) {
    if (buses.minute > 10) {
      minute = buses.minute - 10;
      hour = buses.hour;
    } else {
      minute = 50 + buses.minute;
      hour = buses.hour - 1;
    }
  }

  _scheduledNotificationDateTime(DateTime busTime, DateTime currentTime) {
    if ((busTime.hour - currentTime.hour) * 60 +
            (busTime.minute - currentTime.minute) >=
        0) {
      _busTime = busTime;
      return DateTime.now().add(_busTime.difference(currentTime));
    } else {
      _busTime = busTime.add(new Duration(days: 1));
      return DateTime.now().add(_busTime.difference(currentTime));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget current(bus) {
    if (bus.currentlyRunning) {
      return Icon(
        Icons.adjust,
        color: Colors.green,
      );
    } else {
      return Container();
    }
  }

  Widget busesTemplate(buses) {
    return Card(
      color: theme.cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "From: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: theme.textHeadingColor,
                        ),
                      ),
                      Text(
                        buses.origin,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: theme.textHeadingColor,
                        ),
                      ),
                    ],
                  ),
                  current(buses),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    "To: ",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: theme.textHeadingColor,
                    ),
                  ),
                  Text(
                    buses.destination,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  buses.time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.textHeadingColor),
                ),
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton.icon(
                        color: theme.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                              content: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/logo.png",
                                  image: buses.url),
                            ),
                          );
                        },
                        icon: Icon(Icons.airport_shuttle,
                            color: theme.buttonContentColor),
                        label: Text(
                          'Route',
                          style: TextStyle(
                            color: theme.buttonContentColor,
                          ),
                        )),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.withAlpha(25),
                      // foregroundColor: secondaryColor,
                      child: IconButton(
                        onPressed: () {
                          _showNotificationWithDefaultSound(buses);
                        },
                        icon: Icon(Icons.add_alarm),
                      ),
                    ),
                  ]),
            ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    dataContainer.shuttle.buses.forEach((element) {
      if (!places.contains(element.origin.trim())) {
        places.add(element.origin.trim());
      }
      if (!places.contains(element.destination.trim())) {
        places.add(element.destination.trim());
      }
    });
  }

  void initialize() {
    _scrollController = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(50 + _index * 150.toDouble(),
          duration: new Duration(seconds: 1), curve: Curves.ease);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - 50) {
        isFabVisible = true;
        setState(() {});
      } else {
        isFabVisible = false;
        setState(() {});
      }
    });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: const Text('Bus Reminder'),
              content:
                  new Text('Hey buddy!! You have a bus to catch in 10 minutes'),
            ));
  }

  Future _showNotificationWithDefaultSound(buses) async {
    reminder(buses);

    var busTime = new DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute, 0);
    var currentTime = new DateTime.now();
    var scheduledNotificationDateTime =
        _scheduledNotificationDateTime(busTime, currentTime);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your new channel id',
        'your new channel name',
        'your new channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        content: Text("Reminder is set at: $_busTime"),
      ),
    );

    await flutterLocalNotificationsPlugin.schedule(
        1,
        'Bus Reminder',
        'Hey buddy!! You have a bus to catch to ${buses.destination}',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'item x');
  }

  List<List<Buses>> dividedBuses() {
    List<List<Buses>> _dividedBuses = [[], []];
    if (dataContainer.shuttle.buses != null) {
      dataContainer.shuttle.buses.forEach((Buses bus) {
        if (bus.origin == 'Palaj') {
          _dividedBuses[0].add(bus);
        } else {
          _dividedBuses[1].add(bus);
        }
      });
    }

    return _dividedBuses;
  }

  List<Buses> makeBusList(String origin, String destination) {
    List<Buses> _busList = [];
    List<Buses> busesAccordingToOrigin = [];
    if (origin == 'Origin') {
      busesAccordingToOrigin.addAll(dataContainer.shuttle.buses);
    } else {
      dataContainer.shuttle.buses.forEach((Buses bus) {
        if (bus.origin == origin) {
          busesAccordingToOrigin.add(bus);
        }
      });
    }

    if (destination == 'Destination') {
      _busList.addAll(busesAccordingToOrigin);
    } else {
      busesAccordingToOrigin.forEach((Buses bus) {
        if (bus.destination == destination) {
          _busList.add(bus);
        }
      });
    }

    return _busList;
  }

  bool destinationSelected = false;
  bool isFabVisible = true;
  Widget build(BuildContext context) {
    // initialize();
    if (!destinationSelected) {
      return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Where are you going?",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor),
                ),
                Text(
                  "Let's get you on that bus!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textSubheadingColor),
                ),
                ColumnBuilder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: ScreenSize.size.width,
                      child: Card(
                          color: theme.cardBgColor,
                          child: InkWell(
                            onTap: () {
                              destinationSelected = true;
                              destination = places[index];
                              setState(() {});
                              initialize();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(places[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: theme.textHeadingColor)),
                            ),
                          )),
                    );
                  },
                  itemCount: places.length,
                )
              ],
            ),
          )),
        ),
      );
    }
    List<Buses> busList = makeBusList(this.origin, this.destination);
    busList.forEach((Buses bus) {
      bus.currentlyRunning = false;
    });

    makeBusList(this.origin, this.destination);
    bool getIndex = false;
    DateTime _currentTime = DateTime.now();
    busList.asMap().forEach((int index, Buses bus) {
      DateTime _busTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, bus.hour, bus.minute);
      if (!getIndex && _busTime.isAfter(_currentTime)) {
        _index = index;
        getIndex = true;
        bus.currentlyRunning = true;
      }
    });

    // if (_scrollController.hasClients) {
    //   _scrollController.animateTo(50 + _index * 150.toDouble(),
    //       duration: new Duration(seconds: 1), curve: Curves.ease);
    // }

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButton: Visibility(
        visible: isFabVisible,
        // duration: Duration(milliseconds: 200),
        child: FloatingActionButton(
            backgroundColor: theme.floatingColor,
            onPressed: () {
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeInOut);
            },
            child:
                Icon(Icons.keyboard_arrow_up, color: theme.buttonContentColor)),
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          ExpansionTile(
            key: GlobalKey(),
            title: Row(
              children: <Widget>[
                Text("From: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor,
                    )),
                Text(this.origin,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: theme.textHeadingColor,
                    )),
              ],
            ),
            children: places.map((String place) {
              return ListTile(
                title: Text(place,
                    style: TextStyle(color: theme.textSubheadingColor)),
                onTap: () {
                  setState(() {
                    this.origin = place;
                  });
                },
              );
            }).toList(),
          ),
          ExpansionTile(
            key: GlobalKey(),
            title: Row(
              children: <Widget>[
                Text("To: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor,
                    )),
                Text(this.destination,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: theme.textHeadingColor,
                    )),
              ],
            ),
            children: places.map((String place) {
              return ListTile(
                title: Text(place,
                    style: TextStyle(color: theme.textSubheadingColor)),
                onTap: () {
                  setState(() {
                    this.destination = place;
                  });
                },
              );
            }).toList(),
          ),
          Column(
            children: busList.map((Buses bus) {
              return busesTemplate(bus);
            }).toList(),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
