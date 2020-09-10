/*(beta)import 'package:flutter/material.dart';
import 'package:instiapp/classes/tlclass.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';

Map tlMemberData = {};
String type;
List<Tinkerer> persons;

void customLaunch(command) async {
  if (await canLaunch(command)) {
    await launch(command);
  } else {
    throw 'Could not launch $command';
  }
}

class TinkererContact extends StatefulWidget {
  @override
  _TinkererContactState createState() => _TinkererContactState();
}

class _TinkererContactState extends State<TinkererContact> {
  @override
  void initState() {
    super.initState();
  }

  Widget tlShowWidget(Tinkerer person){
    return GestureDetector(onTap: (){customLaunch('tel:'+person.mobNo);},
    child: Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              (type == 'Machines') ?person.name+ '      ' +person.machine :person.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    ));
  }


  Widget build(BuildContext context) {
    tlMemberData = ModalRoute.of(context).settings.arguments;
    Map<String, List<Tinkerer>> data = tlMemberData['dataList'];
    data.forEach((String _type, List<Tinkerer> _persons) {
      type = _type;
      persons = _persons;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('TL Contacts',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,16),
          child: Column(
            children: persons.map((Tinkerer person) => tlShowWidget(person)).toList())
          ),
        ),
      );

  }
}*/
