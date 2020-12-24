/*(beta)import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/AvailableRooms.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:instiapp/utilities/constants.dart';

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

List<Room> availableRooms;
List<Room> unavailableRooms;

RoomTime userTime;
bool isTimeSelected = false;

DateTime startDate;
DateTime endDate;
TimeOfDay startTime;
TimeOfDay endTime;
DateTime start;
DateTime end;

class _SelectTimeState extends State<SelectTime> {
  @override
  void initState() {
    super.initState();
    isTimeSelected = false;
    print(isTimeSelected);
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

  Widget homeScreen() {
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
        title: Text('Book your slot',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    icon: Icon(Icons.calendar_today, color: Colors.black),
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
                    icon: Icon(Icons.access_time, color: Colors.black),
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
                    icon: Icon(Icons.calendar_today, color: Colors.black),
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
                    icon: Icon(Icons.access_time, color: Colors.black),
                    label: Text(
                      "${endTime.hour.toString().padLeft(2, '0')} : ${endTime.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: RaisedButton.icon(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: _searchForAvailableRooms,
                  icon: Icon(Icons.search, color: Colors.white),
                  label: Text(
                    'Search for rooms',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              (isTimeSelected != true)
                  ? Container()
                  : Container(
                  height: ScreenSize.size.height,
                  width: ScreenSize.size.width,
                  child: AvailableRooms()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return homeScreen();
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
        print(endDate);
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

  _searchForAvailableRooms() {
    double _doubleStartTime =
        startTime.hour.toDouble() + (startTime.minute.toDouble() / 60);
    double _doubleEndTime =
        endTime.hour.toDouble() + (endTime.minute.toDouble() / 60);
    double diff = _doubleEndTime - _doubleStartTime;
    bool beforeDate = endDate.isBefore(startDate);
    bool equalDate = false;
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      equalDate = true;
    }

    if ((beforeDate) || (diff <= 0 && equalDate)) {
      setState(() {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text("Please Enter Appropriate Time and Date!"),
          ),
        );
      });
    } else {
      start = DateTime(startDate.year, startDate.month, startDate.day,
          startTime.hour, startTime.minute);
      end = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour,
          endTime.minute);
      userTime = RoomTime(userId: userID, start: start, end: end);
      searchForRooms(userTime, rooms);
    }
  }

  searchForRooms(RoomTime userTime, List<Room> rooms) {
    availableRooms = [];
    unavailableRooms = [];
    bool onePersonOneBooking = true;
    rooms.forEach((Room room) {
      bool available = true;
      if (room.bookedslots.length != 0) {
        room.bookedslots.forEach((RoomTime time) {
          if (timeClash(userTime, time)) {
            available = false;
            if (userTime.userId == time.userId) {
              onePersonOneBooking = false;
            }
          }
        });
      }
      if (available) {
        availableRooms.add(room);
      } else {
        unavailableRooms.add(room);
      }
    });
    if (onePersonOneBooking) {
      availableRooms.forEach((Room room) {
        print('${room.block}/${room.roomno} is available.');
      });
      unavailableRooms.forEach((Room room) {
        print('${room.block}/${room.roomno} is not available.');
      });
      // Navigator.pushReplacementNamed(context, '/availablerooms');
      isTimeSelected = true;
      setState(() {});
    } else {
      setState(() {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text(
                'Sorry, You can not book any room in this time slot as you have already booked using id: ${userTime.userId}'),
          ),
        );
      });
    }
  }
}*/
