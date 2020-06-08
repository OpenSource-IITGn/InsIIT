import 'package:flutter/material.dart';
import 'package:instiapp/classes/tlclass.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';

class model{
  String title;
  List<Tinkerer> person;

  model({this.title,this.person});
}

List<model> tlList= [model(title:'Lab Access', person: labAccess),model(title:'Inventory Access',person: inventory),
  model(title: 'Machines', person: machinesTL),model(title: 'Course Access', person: courseAccess)];

void customLaunch(command) async{
  if (await canLaunch(command)){
    await launch(command);
  }else{
    throw 'Could not launch $command';
  }
}

List<Tinkerer> inventory = [];
List<Tinkerer> labAccess = [];
List<Tinkerer> courseAccess = [];


class TinkererContact extends StatefulWidget {
  @override
  _TinkererContactState createState() => _TinkererContactState();
}

class _TinkererContactState extends State<TinkererContact> {


  @override
  void initState(){
    super.initState();
    makeTLDataList();
  }

  void makeTLDataList(){
    tlDataList.forEach((Tinkerer time) {
      time.job.forEach((i) {
        if(i == 'Lab Access'){
          labAccess.add(time);
        }
        else if(i == 'Inventory Access'){
          inventory.add(time);
        }
        else if(i == 'Course Access'){
          courseAccess.add(time);
        }
      });
    });
  }
  Widget machineTLhead(name){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        )
      ),
    )
    ;
  }

  Widget body (List<Tinkerer> persons, String title) {
    if (title == 'Machines') {
      return ListView(
        children: persons.map((Tinkerer person) {
          return ListTile(
            title: Text(person.name),
            trailing: Text(person.machine),
             onTap: (){customLaunch('tel:' + person.mobNo);},
          );
        }).toList(),
      );
    } else {
      return ListView(
        children: persons.map((Tinkerer person) {
          return ListTile(
            title: Text(person.name),
             onTap: (){customLaunch('tel:' + person.mobNo);},
          );
        }).toList(),
      );
    }
  }

  Widget build(BuildContext context) {
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
      body: Center(
        child: ListView.builder(itemCount: 4,
            itemBuilder: (BuildContext context, int index){
           return ExpansionTile(
             title: machineTLhead(tlList[index].title),
             children: <Widget>[
               body(tlList[index].person,tlList[index].title)
             ],
           );
            } ),
      ),
    );
  }
}
