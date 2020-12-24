/*(beta)import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instiapp/screens/TLForms/secondPage.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'dart:io';
import 'dart:convert';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  Map machineData = {};
  bool uploading = false;
  int count = 0;

  String type;
  Machine machine;
  Map<String, File> files;

  String purpose = 'Select your purpose';
  List<String> purposes = [
    'Project Course',
    'TC Project',
    'Event(Amalthea, etc.)',
    'Independant'
  ];

  MachineTime userTime;

  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;

  @override
  void initState() {
    super.initState();
    DateTime _currentTime = DateTime.now();
    startDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    endDate = DateTime(
        _currentTime.add(new Duration(hours: 1)).year,
        _currentTime.add(new Duration(hours: 1)).month,
        _currentTime.add(new Duration(hours: 1)).day);
    startTime = TimeOfDay.fromDateTime(_currentTime);
    endTime = TimeOfDay.fromDateTime(_currentTime.add(new Duration(hours: 1)));
  }

  checkCorrectTime(MachineTime time, Machine machine) {
    if (time.end.isAfter(time.start)) {
      if (time.end.difference(time.start).inHours <= 2) {
        checkTimeClash(time, machine, 'approved');
      } else if (time.end.difference(time.start).inHours <= 6) {
        checkTimeClash(time, machine, 'pending');
      } else {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text("Sorry you can not book a machine for more than 6 hours!"),
          ),
        );
      }
    } else {
      setState(() {
        this.purpose = purpose;
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text("Please Enter Appropriate Time and Date!"),
          ),
        );
      });
    }
  }

  checkTimeClash(MachineTime time, Machine machine, String status) {
    bool clash = false;
    machine.bookedSlotsWithFiles.forEach((MachineTime machineTime) {
      if (clash == false) {
        if (timeClashMachine(time, machineTime)) {
          clash = true;
        }
      }
    });
    if (clash) {
      setState(() {
        this.purpose = purpose;
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text("Please Enter Appropriate Time and Date!"),
          ),
        );
      });
    } else {
      bookMachine(time, machine, status);
    }
  }

  bookMachine(MachineTime time, Machine machine, String status) async{

    var queryParameters = {
      'api_key': 'GULLU',
      'machine_id': machine.machineId,
    };
    var uri1 = Uri.https(
      baseUrlTL,
      '/addBookingFile',
      queryParameters,
    );
    var uri2 = Uri.https(
      baseUrlTL,
      '/addBooking',
      queryParameters,
    );
    List<String> fileNames = [];
    files.forEach((String type, File file) {
      fileNames.add(machine.machineId +
          '&' +
          time.start.millisecondsSinceEpoch.toString() +
          '_' +
          time.end.millisecondsSinceEpoch.toString() +
          '.' +
          type);
    });
    print('Booking ' + machine.model + ': ' + uri1.toString());
    var jsonBody = jsonEncode({
      "booked_by": {
        "user_id": time.userId,
        "full_name": time.name,
        "image_link": time.url,
        "bio": time.bio,
        "contact": time.mobNo,
      },
      "purpose": time.purpose,
      "start": time.start.millisecondsSinceEpoch,
      "end": time.end.millisecondsSinceEpoch,
      "url_of_uploaded_files": time.urlOfUploadedFiles,
      "status": status
    });
    print(jsonBody);
    setState(() {
      uploading = true;
    });
    uploadData(uri2, jsonBody);
    files.forEach((String type, File file) {
      String filename = machine.machineId +
          '&' +
          time.start.millisecondsSinceEpoch.toString() +
          '_' +
          time.end.millisecondsSinceEpoch.toString() +
          '.' +
          type;
      uploadFile(uri1, filename, file);
    });
  }

  uploadData(var uri, var jsonBody) async {
    var response =
        await http.post(uri, body: jsonBody, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    setState(() {
      count++;
      if (count == files.length + 1) {
        uploading = false;
        //print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
        // Navigator.pushReplacementNamed(context, '/menuBarBase');
        Navigator.popUntil(context, ModalRoute.withName('/RoomBooking'));
      }
    });
    print(response.statusCode);
  }

  uploadFile(var uri, String filename, File file) async {
    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromBytes(
        'file', file.readAsBytesSync(),
        filename: filename, contentType: MediaType('application', 'x-tar')));
    var response = await request.send();
    setState(() {
      count++;
      if (count == files.length + 1) {
        uploading = false;
        //print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
       Navigator.popUntil(context, ModalRoute.withName('/RoomBooking'));
      }
    });
    print(response.statusCode);
  }

  Widget homeScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Text(
                    'From: ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                OutlineButton.icon(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: _pickStartDate,
                  icon: Icon(Icons.calendar_today, color: primaryColor),
                  label: Text(
                    "${startDate.day.toString().padLeft(2, '0')} / ${startDate.month.toString().padLeft(2, '0')} / ${startDate.year}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                OutlineButton.icon(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: _pickStartTime,
                  icon: Icon(Icons.access_time, color: primaryColor),
                  label: Text(
                    "${startTime.hour.toString().padLeft(2, '0')} : ${startTime.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Text(
                    'To:      ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                OutlineButton.icon(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: _pickEndDate,
                  icon: Icon(Icons.calendar_today, color: primaryColor),
                  label: Text(
                    "${endDate.day.toString().padLeft(2, '0')} / ${endDate.month.toString().padLeft(2, '0')} / ${endDate.year.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                OutlineButton.icon(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: _pickEndTime,
                  icon: Icon(Icons.access_time, color: primaryColor),
                  label: Text(
                    "${endTime.hour.toString().padLeft(2, '0')} : ${endTime.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            // Column(
            //   children: <Widget>[
            //     Center(
            //       child: Text(
            //         'From',
            //         style: TextStyle(
            //           fontSize: 20,
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 20,
            //     ),
            //     Row(
            //       children: <Widget>[
            //         Expanded(
            //           flex: 1,
            //           child: ListTile(
            //             title: Center(
            //                 child: Text(
            //               "Date",
            //             )),
            //             subtitle: Center(
            //                 child: Text(
            //               "${startDate.day} / ${startDate.month} / ${startDate.year}",
            //               style: TextStyle(
            //                 color: Colors.grey[800],
            //               ),
            //             )),
            //             trailing: Icon(
            //               Icons.calendar_today,
            //             ),
            //             onTap: _pickStartDate,
            //           ),
            //         ),
            //         Expanded(
            //           flex: 1,
            //           child: ListTile(
            //             title: Center(
            //                 child: Text(
            //               "Time",
            //             )),
            //             subtitle: Center(
            //               child: Text(
            //                 "${startTime.hour} : ${startTime.minute}",
            //                 style: TextStyle(
            //                   color: Colors.grey[800],
            //                 ),
            //               ),
            //             ),
            //             trailing: Icon(
            //               Icons.access_time,
            //             ),
            //             onTap: _pickStartTime,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Divider(
            //   indent: 40,
            //   endIndent: 40,
            //   color: Colors.grey[800],
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Column(
            //   children: <Widget>[
            //     Center(
            //       child: Text(
            //         'To',
            //         style: TextStyle(
            //           fontSize: 20,
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 20,
            //     ),
            //     Row(
            //       children: <Widget>[
            //         Expanded(
            //           flex: 1,
            //           child: ListTile(
            //             title: Center(
            //               child: Text(
            //                 "Date",
            //               ),
            //             ),
            //             subtitle: Center(
            //               child: Text(
            //                 "${endDate.day} / ${endDate.month} / ${endDate.year}",
            //                 style: TextStyle(
            //                   color: Colors.grey[800],
            //                 ),
            //               ),
            //             ),
            //             trailing: Icon(
            //               Icons.calendar_today,
            //             ),
            //             onTap: _pickEndDate,
            //           ),
            //         ),
            //         Expanded(
            //           flex: 1,
            //           child: ListTile(
            //             title: Center(
            //               child: Text(
            //                 "Time",
            //               ),
            //             ),
            //             subtitle: Center(
            //               child: Text(
            //                 "${endTime.hour} : ${endTime.minute}",
            //                 style: TextStyle(
            //                   color: Colors.grey[800],
            //                 ),
            //               ),
            //             ),
            //             trailing: Icon(
            //               Icons.access_time,
            //             ),
            //             onTap: _pickEndTime,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // Divider(
            //   indent: 40,
            //   endIndent: 40,
            //   color: Colors.grey[800],
            // ),
            // SizedBox(
            //   height: 80,
            // ),
            ExpansionTile(
              key: GlobalKey(),
              title: Text(
                purpose,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: purposes.map((String text) {
                return ListTile(
                  title: Text(
                    text,
                  ),
                  onTap: () {
                    setState(() {
                      this.purpose = text;
                      this.startDate = startDate;
                      this.startTime = startTime;
                      this.endDate = endDate;
                      this.endTime = endTime;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: FlatButton.icon(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (purpose == 'Select your purpose') {
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Text('Please select your purpose'),
                      ),
                    );
                  } else {
                    DateTime start = DateTime(startDate.year, startDate.month,
                        startDate.day, startTime.hour, startTime.minute);
                    DateTime end = DateTime(endDate.year, endDate.month,
                        endDate.day, endTime.hour, endTime.minute);
                    checkCorrectTime(
                        MachineTime(
                            userId: userID,
                            name: firebaseUser.displayName,
                            mobNo: userMobileNumber,
                            bio: userBio,
                            start: start,
                            end: end,
                            purpose: purpose,
                            url: firebaseUser.photoUrl,
                            urlOfUploadedFiles: [
                              'gcodefile',
                              'stlfile',
                              'imgfile'
                            ]),
                        machine);
                  }
                },
                label: Text(
                  'Book ' + machine.model,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _pickStartDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: startDate,
    );
    if (date != null)
      setState(() {
        startDate = DateTime(date.year, date.month, date.day);
      });
  }

  _pickEndDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: endDate,
    );
    if (date != null)
      setState(() {
        endDate = DateTime(date.year, date.month, date.day);
      });
  }

  _pickStartTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: startTime);
    if (t != null)
      setState(() {
        startTime = t;
      });
  }

  _pickEndTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: endTime);
    if (t != null)
      setState(() {
        endTime = t;
      });
  }

  Widget loadScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Image.asset('assets/images/loading.png'),
          SizedBox(
            height: 40,
          ),
          Column(
            children: <Widget>[
              Text(
                'Your files are being Uploaded',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8,),
              Text(
                'Please wait for a few minutes....',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    machineData = ModalRoute.of(context).settings.arguments;
    type = machineData['type'];
    machine = machineData['machine'];
    files = machineData['files'];

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
          title: Text('Finish Booking',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        body: (uploading == true && count != files.length + 1)
            ? loadScreen()
            : homeScreen());
  }
}*/
