import 'package:flutter/material.dart';
import 'package:instiapp/classes/Constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instiapp/classes/buses.dart';

class Shuttle extends StatefulWidget {

  @override
  _ShuttleState createState() => _ShuttleState();
}

class _ShuttleState extends State<Shuttle> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Buses> buses = [
    Buses (destination:'Destination:Visat Circle',time: '@ 8:30 AM', image: Image(image: AssetImage('assets/VisatCircle.jpg')),hour: 8,minute: 30 ),
    Buses (destination:'Destination:Kudasan Circle',time: '@ 10:30 AM', image: Image(image: AssetImage('assets/Kudasan.jpg')),hour:10,minute: 30),
    Buses (destination:'Destination:Pathikashram',time: '@ 12:30 PM', image: Image(image: AssetImage('assets/Pathikashram.jpg')),hour:12,minute: 30),
    Buses (destination:'Destination:Infocity',time: '@ 1 PM', image: Image(image: AssetImage('assets/infocity.jpg')),hour:13,minute: 0 ),

  ];

  Widget busesTemplate(buses) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(buses.destination,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 6.0,),
              Text(buses.time,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              RaisedButton.icon(onPressed: () {
                showDialog(context: context,
                  builder: (_) => new AlertDialog(
                    title: Text('Route'),
                    content:  buses.image,),

                );
              },
                  icon: Icon(Icons.airport_shuttle),
                  label: Text('Route')),
              RaisedButton.icon(onPressed: (){
                _showNotificationWithDefaultSound(buses);
              }, icon: Icon(Icons.access_alarm), label: Text('Reminder'))

            ]
        ),
      ),
    );
  }

  @override

  void initState(){
    super.initState();

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid,initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification : onSelectNotification);

  }

  Future onSelectNotification(String payload) async{
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: const Text('Bus Reminder'),
          content: new Text('Hey buddy!! You have a bus to catch in 10 minutes'),
        )
    );
  }

  Future _showNotificationWithDefaultSound(buses) async {
    var busTime = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, buses.hour, buses.minute, 0);
    var currentTime = new DateTime.now();
    var scheduledNotificationDateTime = DateTime.now().add(busTime.difference(currentTime));
    print(busTime);
    print(currentTime);
    print(DateTime.now().add(busTime.difference(currentTime)));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your new channel id', 'your new channel name', 'your new channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker'
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics
    );
    await flutterLocalNotificationsPlugin.schedule(
        1, 'Bus Reminder', 'Hey buddy!! You have a bus to catch.', scheduledNotificationDateTime, platformChannelSpecifics,
        payload: 'item x'
    );
  }




  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Bus Schedule'),
          centerTitle: true,
          backgroundColor: Colors.cyan,
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: (choice){ Navigator.pushNamed(context,'/$choice');} ,
                itemBuilder: (BuildContext context) {
                  return Constants.Choices.map((String choice) {
                    return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice)
                    );

                  },
                  ).toList();
                }
            ),
          ],
        ),
        body: Column(
          children: buses.map((buses) => busesTemplate(buses)).toList(),
        )
    );
  }

}
