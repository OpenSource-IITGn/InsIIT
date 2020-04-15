

import 'package:flutter/material.dart';
import './Constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './Contacts.dart';
import './buses.dart';






void main() => runApp(MaterialApp(
  home: Home(),
),
);
class Home extends StatefulWidget {


  @override



  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



  List<Buses> buses = [
    Buses (Destination:'Destination:Visat Circle',Time: '@ 8:30 AM', image: Image(image: AssetImage('assets/VisatCircle.jpg')),hour: 8,minute: 30 ),
    Buses (Destination:'Destination:Kudasan Circle',Time: '@ 10:30 AM', image: Image(image: AssetImage('assets/Kudasan.jpg')),hour:10,minute: 30),
    Buses (Destination:'Destination:Pathikashram',Time: '@ 12:30 PM', image: Image(image: AssetImage('assets/Pathikashram.jpg')),hour:12,minute: 30),
    Buses (Destination:'Destination:Infocity',Time: '@ 1 PM', image: Image(image: AssetImage('assets/infocity.jpg')),hour:15,minute: 25 ),

  ];

  Widget busestemplate(Buses) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(Buses.Destination,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 6.0,),
              Text(Buses.Time,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              RaisedButton.icon(onPressed: () {
                showDialog(context: context,
                           builder: (_) => new AlertDialog(
                             title: Text('Route'),
                             content:  Buses.image,),

                         );
              },
                  icon: Icon(Icons.airport_shuttle),
                  label: Text('Route')),
              RaisedButton.icon(onPressed: (){
                _showNotificationWithDefaultSound(Buses);
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

  Future _showNotificationWithDefaultSound(Buses) async {
    var busTime = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, Buses.hour, Buses.minute, 0);
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
          children: buses.map((Buses) => busestemplate(Buses)).toList(),
        )
    );
  }

}
