import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instiapp/classes/buses.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/screens/homePage.dart';

//TODO: ADD LINK TO GOOGLE MAP ROUTEs
class Shuttle extends StatefulWidget {
  @override
  _ShuttleState createState() => _ShuttleState();
}

class _ShuttleState extends State<Shuttle> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  ScrollController _scrollController;
  int _index = 0;
  int hour;
  int minute;
  DateTime _busTime;
  String origin = 'Origin';
  String destination = 'Destination';
  List<String> places = ['Palaj', 'Visat Circle', 'Kudasan', 'Infocity', 'RakshaShakti', 'Pathikashram'];

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
    if ((busTime.hour - currentTime.hour)*60 + (busTime.minute - currentTime.minute) >= 0) {
      _busTime = busTime;
      return DateTime.now().add(_busTime.difference(currentTime));
    } else {
      _busTime = busTime.add(new Duration(days: 1));
      return DateTime.now().add(_busTime.difference(currentTime));
    }
  }

  Widget current (bus) {
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
                        ),
                      ),
                      Text(
                        buses.origin,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
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
                    ),
                  ),
                  Text(
                    buses.destination,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton.icon(
                        color: Colors.grey.withAlpha(25),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                              content: Image.network(
                                buses.url,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                          .expectedTotalBytes !=
                                          null
                                          ? loadingProgress
                                          .cumulativeBytesLoaded /
                                          loadingProgress
                                              .expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.airport_shuttle),
                        label: Text('Route')),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.withAlpha(25),
                      foregroundColor: secondaryColor,
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

    _scrollController = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _scrollController.animateTo(50 + _index*150.toDouble(), duration: new Duration(seconds: 1), curve: Curves.ease);
    });

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
    var scheduledNotificationDateTime = _scheduledNotificationDateTime(busTime, currentTime);
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

  List<List<Buses>> dividedBuses () {
    List<List<Buses>> _dividedBuses = [[],[]];
    if (buses != null) {
      buses.forEach((Buses bus) {
        if (bus.origin == 'Palaj') {
          _dividedBuses[0].add(bus);
        } else {
          _dividedBuses[1].add(bus);
        }
      });
    }

    return _dividedBuses;
  }

  List<Buses> makeBusList (String origin, String destination) {
    List<Buses> _busList = [];
    List<Buses> busesAccordingToOrigin = [];
    if (origin == 'Origin') {
      busesAccordingToOrigin.addAll(buses);
    } else {
      buses.forEach((Buses bus) {
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

  Widget build(BuildContext context) {

    List<Buses> busList = makeBusList(this.origin, this.destination);

    makeBusList(this.origin, this.destination);
    bool getIndex = false;
    DateTime _currentTime = DateTime.now();
    busList.asMap().forEach((int index, Buses bus) {
      DateTime _busTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, bus.hour, bus.minute);
      if (!getIndex && _busTime.isAfter(_currentTime)) {
        _index = index;
        getIndex = true;
        bus.currentlyRunning = true;
      }
    });

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ExpansionTile(
                      key: GlobalKey(),
                      title: Text(this.origin),
                      children: places.map((String place) {
                        return ListTile(
                          title: Text(place),
                          onTap: () {
                            setState(() {
                              this.origin = place;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ExpansionTile(
                      key: GlobalKey(),
                      title: Text(this.destination),
                      children: places.map((String place) {
                        return ListTile(
                          title: Text(place),
                          onTap: () {
                            setState(() {
                              this.destination = place;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
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
}


