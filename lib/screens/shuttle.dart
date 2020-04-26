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
  int Hour;
  int Minute;


  void Reminder(buses){
    if (buses.minute>10){
      Minute = buses.minute-10;
      Hour= buses.hour;
    }
    else{
      Minute = 50+buses.minute;
      Hour = buses.hour-1;
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
                      buses.Origin,
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
                      buses.Destination,
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
                    buses.Time,
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
                                content: Image.network(buses.url),
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
                          icon: Icon(Icons.access_alarm),
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
    Reminder(buses);

    var busTime = new DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, Hour, Minute, 0);
    var currentTime = new DateTime.now();
    var scheduledNotificationDateTime =
        DateTime.now().add(busTime.difference(currentTime));
    print(busTime);
    print(currentTime);
    print(DateTime.now().add(busTime.difference(currentTime)));
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
