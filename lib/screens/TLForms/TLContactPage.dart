import 'package:flutter/material.dart';
import 'package:instiapp/classes/tlclass.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';

Map tlMemberData = {};
class model{
  String title;
  List<Tinkerer> person;

  TLModel({this.title, this.person});
}



List<model> tlList= [model(title:'Lab Access', person: labAccess),model(title:'Inventory Access',person: inventory),
  model(title: 'Machines', person: machinesTL),model(title: 'Course Access', person: courseAccess)];

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
    print(labAccess);
    print(inventory);
    print(courseAccess);
    return GestureDetector(onTap: (){customLaunch('tel:'+person.mobNo);},
    child: Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              (person.isMachine)?person.name+'      '+person.machine:person.name,
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
    List<Tinkerer> data = tlMemberData['dataList'];

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
            children: data.map((Tinkerer person) => tlShowWidget(person)).toList())
          ),
        ),
      );

  }
}
