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
  int hour;
  int minute;
  DateTime _busTime;

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

  Widget busesTemplate(buses) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
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

  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Bus Schedule'),
          centerTitle: true,
          backgroundColor: secondaryColor,
          // actions: <Widget>[
          //   PopupMenuButton<String>(onSelected: (choice) {
          //     Navigator.pushNamed(context, '/$choice');
          //   }, itemBuilder: (BuildContext context) {
          //     return Constants.Choices.map(
          //       (String choice) {
          //         return PopupMenuItem<String>(
          //             value: choice, child: Text(choice));
          //       },
          //     ).toList();
          //   }),
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: buses.map((buses) => busesTemplate(buses)).toList(),
          ),
        ));
  }
}
