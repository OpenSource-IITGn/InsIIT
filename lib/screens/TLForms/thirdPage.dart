/*(beta)import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'dart:io';

import 'package:instiapp/utilities/constants.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  Map machineData = {};

  String type;
  List<Machine> machines;
  Map<String, File> files;

  Widget machineCard(Machine machine) {
    return Card(
      child: Container(
        color: Colors.white,
        width: ScreenSize.size.width * 1,
        // height: ScreenSize.size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/fourthPage',
                  arguments: {
                    'type': type,
                    'machine': machine,
                    'files': files,
                  });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  machine.model,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                Text(
                  machine.type,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Choose Preferred Machine',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: machines.map((Machine machine) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                child: machineCard(machine),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}*/
