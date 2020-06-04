import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/Selecttime.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/utilities/constants.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  TextEditingController _mobileNoController;
  TextEditingController _purposeController;

  Map roomData = {};

  void initState() {
    super.initState();
    _mobileNoController = TextEditingController();
    _purposeController = TextEditingController();
  }

  void dispose() {
    _mobileNoController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  bookRoom(RoomTime time, Room room) {
    //TODO: BookRoom
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
      body: Padding(
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
                  gSignIn.currentUser.displayName,
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
              color: Colors.black,
              onPressed: () {
                if (_mobileNoController.text == '' ||
                    _purposeController.text == '') {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      content: Text("Please Enter Mobile number and purpose!"),
                    ),
                  );
                } else {
                  bookRoom(
                      RoomTime(
                          userId: gSignIn.currentUser.email,
                          name: gSignIn.currentUser.displayName,
                          mobNo: _mobileNoController.text,
                          start: start,
                          end: end,
                          purpose: _purposeController.text),
                      Room(
                          block: roomData['_block'],
                          roomno: roomData['_room']));
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
    );
  }
}
