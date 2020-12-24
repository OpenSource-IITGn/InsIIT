/*(beta)import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/Selecttime.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:http/http.dart' as http;

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  bool loadingBooking = false;
  TextEditingController _mobileNoController;
  TextEditingController _purposeController;
  TextEditingController _bioController;

  Map roomData = {};

  void initState() {
    super.initState();
    _mobileNoController = TextEditingController();
    _purposeController = TextEditingController();
    _bioController = TextEditingController();

  }

  void dispose() {
    _mobileNoController.dispose();
    _purposeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  bookRoom(RoomTime time, Room room) async {
    var queryParameters = {
      'api_key': 'NIKS',
      'room_id': room.roomId,
    };
    var uri = Uri.https(
      baseUrl,
      '/addBooking',
      queryParameters,
    );
    print('Booking Room: ' + uri.toString());
    var jsonBody = jsonEncode({
      "booked_by": {
        "user_id": time.userId,
        "full_name": time.name,
        "image_link": time.url,
        "bio": time.bio,
        "contact": int.parse(time.mobNo),
      },
      "purpose": time.purpose,
      "start": time.start.millisecondsSinceEpoch,
      "end": time.end.millisecondsSinceEpoch,
    });
    print(jsonBody);
    loadingBooking = true;
    setState(() {});
    var response =
        await http.post(uri, body: jsonBody, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    loadingBooking = false;
    print(response.statusCode);
    //print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
    Navigator.popUntil(context, ModalRoute.withName('/RoomBooking'));
  }

  @override
  Widget build(BuildContext context) {
    roomData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
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
        title: Text('Confirm booking',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: (loadingBooking == true)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Name:',
                          style: TextStyle(
                            // fontSize: 20,
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
                      keyboardType: TextInputType.phone,
                      controller: _mobileNoController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Purpose',
                      ),
                      controller: _purposeController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your Bio',
                      ),
                      controller: _bioController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: <Widget>[
                        Text(" ${roomData['_block']}/${roomData['_room']}",
                            style: TextStyle(
                              // fontSize: 12,
                              // fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(150),
                            )),
                        Text(
                            " ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} to ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              // fontSize: 12,
                              fontStyle: FontStyle.italic,
                              // fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(150),
                            )),
                      ],
                    ),
                    SizedBox(height: 10),
                    RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: primaryColor,
                      onPressed: () {
                        if (_mobileNoController.text == '' ||
                            _purposeController.text == '' ||
                            _bioController.text == '') {
                          showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                              content: Text(
                                  "Please Enter Mobile number,purpose and bio!"),
                            ),
                          );
                        } else {
                          bookRoom(
                              RoomTime(
                                  userId: firebaseUser.email,
                                  name: firebaseUser.displayName,
                                  mobNo: _mobileNoController.text,
                                  start: start,
                                  end: end,
                                  purpose: _purposeController.text,
                                  bio: _bioController.text,
                                  url: firebaseUser.photoUrl),
                              Room(
                                  block: roomData['_block'],
                                  roomno: roomData['_room'],
                                  roomId: roomData['_id']));
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Book',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}*/
