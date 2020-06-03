import 'package:flutter/material.dart';
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
    DateTime _currentTime = DateTime.now();
    startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    endDate = DateTime(_currentTime.add(new Duration(hours: 1)).year, _currentTime.add(new Duration(hours: 1)).month, _currentTime.add(new Duration(hours: 1)).day);
    startTime = TimeOfDay.fromDateTime(_currentTime);
    endTime = TimeOfDay.fromDateTime(_currentTime.add(new Duration(hours: 1)));
  }

  Widget homeScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Select Time'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'From',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Center(
                            child: Text(
                              "Date",
                            )
                        ),
                        subtitle: Center(
                            child: Text(
                              "${startDate.day} / ${startDate.month} / ${startDate.year}",
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            )
                        ),
                        trailing: Icon(
                          Icons.calendar_today,
                        ),
                        onTap: _pickStartDate,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Center(
                            child: Text(
                              "Time",
                            )),
                        subtitle: Center(
                          child: Text(
                            "${startTime.hour} : ${startTime.minute}",
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.access_time,
                        ),
                        onTap: _pickStartTime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30,),
            Divider(indent: 40, endIndent: 40, color: Colors.grey[800],),
            SizedBox(height: 30,),
            Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'To',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Center(
                          child: Text(
                            "Date",
                          ),
                        ),
                        subtitle: Center(
                          child: Text(
                            "${endDate.day} / ${endDate.month} / ${endDate.year}",
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.calendar_today,
                        ),
                        onTap: _pickEndDate,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Center(
                          child: Text(
                            "Time",
                          ),
                        ),
                        subtitle: Center(
                          child: Text(
                            "${endTime.hour} : ${endTime.minute}",
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.access_time,
                        ),
                        onTap: _pickEndTime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(indent: 40, endIndent: 40, color: Colors.grey[800],),
            SizedBox(height: 80,),
            Center(
              child: FlatButton(
                color: primaryColor,
                onPressed: _searchForAvailableRooms,
                child: Text(
                  'Search For Available Rooms',
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

  @override
  Widget build(BuildContext context) {
    return homeScreen();
  }

  _pickStartDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: startDate,
    );
    if(date != null)
      setState(() {
        startDate = DateTime(date.year, date.month, date.day);
      });
  }

  _pickEndDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: endDate,
    );
    if(date != null)
      setState(() {
        endDate = DateTime(date.year, date.month, date.day);
      });
  }

  _pickStartTime() async {
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: startTime
    );
    if(t != null)
      setState(() {
        startTime = t;
      });
  }

  _pickEndTime() async {
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: endTime
    );
    if(t != null)
      setState(() {
        endTime = t;
      });
  }

  _searchForAvailableRooms() {
    double _doubleStartTime = startTime.hour.toDouble() + (startTime.minute.toDouble() / 60);
    double _doubleEndTime = endTime.hour.toDouble() + (endTime.minute.toDouble() / 60);
    double diff = _doubleEndTime - _doubleStartTime;
    bool beforeDate = endDate.isBefore(startDate);
    bool equalDate = false;
    if (startDate.year == endDate.year && startDate.month == endDate.month && startDate.day == endDate.day) {
      equalDate = true;
    }

    if((beforeDate) || (diff <= 0 && equalDate)){
      setState(() {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text("Please Enter Appropriate Time and Date!"),
          ),
        );
      });
    }
    else{
      start = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour,startTime.minute);
      end = DateTime(endDate.year,endDate.month,endDate.day,endTime.hour,endTime.minute);
      userTime = RoomTime(userId: userID, start: start, end: end);
      searchForRooms(userTime, rooms);
    }

  }

  searchForRooms (RoomTime userTime, List<Room> rooms) {
    availableRooms = [];
    unavailableRooms = [];
    bool onePersonOneBooking = true;
    rooms.forEach((Room room) {
      bool available = true;
      if (room.bookedslots.length != 0) {
        room.bookedslots.forEach((RoomTime time) {
          if (timeClash(userTime, time)) {
            available = false;
            if (userTime.userId ==time.userId) {
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
      Navigator.pushReplacementNamed(context, '/availablerooms');
    } else {
      setState(() {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            content: Text('Sorry, You can not book any room in this time slot as you have already booked using id: ${userTime.userId}'),
          ),
        );
      });
    }
  }
}




