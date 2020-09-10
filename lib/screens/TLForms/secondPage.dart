/*(beta)import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:instiapp/screens/homePage.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

String userMobileNumber;
String userBio;

class _SecondPageState extends State<SecondPage> {
  Map machineData = {};
  List<dynamic> allowedExtensions = [];
  List<Widget> buttons = [];
  Map<String, File> files = {};
  TextEditingController _mobileNoController;
  TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _mobileNoController = TextEditingController();
    _bioController = TextEditingController();
  }

  getTime (File file) async {
    var content = '';
    try {
      content = await file.readAsString();
    } catch(e) {
      print(e);
    }
    var newContent = content.split(';');
    var timeContent = '';
    newContent.forEach((var text) {
      if (text.replaceAll(' ', '').contains(new RegExp('buildtime', caseSensitive: false))) {
        timeContent = text;
      }
    });
    var time = timeContent.split(':')[1];
    int hour = int.parse(time.split('hours')[0]);
    int minutes = int.parse(time.split('hours')[1].split('minutes')[0]);
    double printTime = hour + minutes/60;
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        content: Text('Estimated Print Time: ' + printTime.toString() + 'h'),
      ),
    );
  }

  void dispose() {
    _mobileNoController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    machineData = ModalRoute.of(context).settings.arguments;
    String type = machineData['type'];
    List<Machine> machines = machineData['machines'];
    allowedExtensions = machines[0].allowedExtensions;
    buttons = [];
    allowedExtensions.forEach((var extension) {
      List<String> extensions = [];
      String text;
      if (extension.contains('/')) {
        extensions = extension.split('/');
        text = extensions[0] + ' or ' + extensions[1];
      } else {
        extensions.add(extension);
        text = extensions[0];
      }
      buttons.add(Column(
        children: <Widget>[
          OutlineButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            onPressed: () async {
              File file = await FilePicker.getFile(
                type: FileType.custom,
                allowedExtensions: extensions,
              );
              if (file != null) {
                files.putIfAbsent(extension, () => file);
                if (file.path.split('/').last.split('.').last == 'gcode') {
                  getTime(file);
                }
              }
            },
            child: Text('Choose ' + text + ' file'),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ));
    });

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
        title: Text('TL Booking',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    firebaseUser.displayName,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile Number',
                ),
                controller: _mobileNoController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Bio',
                ),
                controller: _bioController,
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: buttons,
              ),
              FlatButton.icon(
                label: Text('Book machine!',
                    style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (files.length == allowedExtensions.length &&
                      !(_mobileNoController.text == '') &&
                      !(_bioController.text == '')) {
                    userMobileNumber = _mobileNoController.text;
                    userBio = _bioController.text;
                    Navigator.pushNamed(context, '/thirdPage',
                        arguments: {
                          'type': type,
                          'machines': machines,
                          'files': files,
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Text(
                            'Please provide your mobile number, bio and Files'),
                      ),
                    );
                  }
                },
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
