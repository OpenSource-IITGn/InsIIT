import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'dart:io';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  Map machineData = {};

  String type;
  List<Machine> machines;
  Map<String, File> files;

  Widget machineCard (Machine machine) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(machine.type),
              SizedBox(height: 5,),
              Text(machine.model),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/fourthPage', arguments: {
                    'type': type,
                    'machine': machine,
                    'files': files,
                  });
                },
                child: Text('Book'),
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    machineData = ModalRoute.of(context).settings.arguments;
    type = machineData['type'];
    machines = machineData['machines'];
    files = machineData['files'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            selectedIndex = 4;
            Navigator.pushReplacementNamed(context, '/menuBarBase');
          },
        ),
        title: Text('Step 2',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: machines.map((Machine machine) {
            return machineCard(machine);
          }).toList(),
        ),
      ),
    );
  }
}
