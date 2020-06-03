import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/Selecttime.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';

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
    String sheetName = '${room.block}/${room.room}';
    List data = [[time.id, time.name, time.mobileNo, '${time.startDate.day}/${time.startDate.month}/${time.startDate.year}', '${time.startTime.hour}:${time.startTime.minute}', '${time.endDate.day}/${time.endDate.month}/${time.endDate.year}', '${time.endTime.hour}:${time.endTime.minute}', time.status, time.purpose]];
    roomSheet.writeData(data, '$sheetName!A:I').then((onValue) {
      Navigator.pushReplacementNamed(context, '/RoomBooking');
    });
  }

  @override
  Widget build(BuildContext context) {

    roomData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Your Details'),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0,),
            Row(
              children: <Widget>[
                Text(
                  'Name:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  gSignIn.currentUser.displayName,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile Number',),
              controller: _mobileNoController,
            ),
            SizedBox(height: 20.0,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Purpose',),
              controller: _purposeController,
            ),
            SizedBox(height: 20.0,),
            FlatButton(
              onPressed: () {
                if (_mobileNoController.text == '' || _purposeController.text == '') {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      content: Text("Please Enter Mobile number and purpose!"),
                    ),
                  );
                } else {
                  bookRoom(RoomTime(id: gSignIn.currentUser.email, name: gSignIn.currentUser.displayName, mobileNo: _mobileNoController.text, startDate: startDate, startTime: startTime, endDate: endDate, endTime: endTime, status: '-', purpose: _purposeController.text), Room(block: roomData['_block'], room: roomData['_room']));
                }
              },
              child: Text('Book ${roomData['_block']}/${roomData['_room']}'),
            )
          ],
        ),
      ),
    );
  }
}


