import 'package:flutter/material.dart';

class RoomTime {

  String id;
  String name;
  String mobileNo;
  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  TimeOfDay endTime;
  String status;
  String purpose;

  RoomTime({this.id, this.name, this.mobileNo, this.startDate, this.startTime, this.endDate, this.endTime, this.status, this.purpose});

}

class Room {

  String block;
  String room;
  String capacity;
  String roomType;
  String facility;
  List<RoomTime> bookedTimes;

  Room({this.block, this.room, this.capacity, this.roomType, this.facility, this.bookedTimes});
}

class YourRoom{
  String id;
  String block;
  String roomNo;
  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  TimeOfDay endTime;
  String purpose;

  YourRoom({this.id, this.block, this.roomNo, this.startDate, this.startTime, this.endDate, this.endTime, this.purpose});

}


class ItemModelSimple {
  bool isExpanded;
  String header;
  List<RoomTime> bodyModel;

  ItemModelSimple({this.isExpanded: false, this.header, this.bodyModel});
}

class ItemModel {
  bool isExpanded;
  String header;
  List<Room> bodyModel;

  ItemModel({this.isExpanded: false, this.header, this.bodyModel});
}


class ItemModelComplex {
  bool isExpanded;
  String header;
  List<Room> bodyModel;
  List<ItemModelSimple> timesOfRooms;

  ItemModelComplex({this.isExpanded: false, this.header, this.bodyModel, this.timesOfRooms});

}



bool timeClash(RoomTime userTime, RoomTime roomTime) {
  if (roomTime.status != '-') {
    return false;
  } else if (userTime.endDate.isBefore(roomTime.startDate)) {
    return false;
  } else if (userTime.startDate.isAfter(roomTime.endDate)) {
    return false;
  } else if (((userTime.endDate.year == roomTime.startDate.year) && (userTime.endDate.month == roomTime.startDate.month) && (userTime.endDate.day == roomTime.startDate.day)) && ((userTime.endTime.hour.toDouble() + (userTime.endTime.minute.toDouble())/60) - (roomTime.startTime.hour.toDouble() + (roomTime.startTime.minute.toDouble())/60) <= 0)) {
    return false;
  } else if (((userTime.startDate.year == roomTime.endDate.year) && (userTime.startDate.month == roomTime.endDate.month) && (userTime.startDate.day == roomTime.endDate.day)) && ((userTime.startTime.hour.toDouble() + (userTime.startTime.minute.toDouble())/60) - (roomTime.endTime.hour.toDouble() + (roomTime.endTime.minute.toDouble())/60) >= 0)) {
    return false;
  } else {
    return true;
  }
}

List makeTimeList (List room) {
  if (room.length == 1) {
    room = [];
  } else {
    room.removeAt(0);
  }
  return room;
}

RoomTime customizeTimeData (List roomTime) {
  String _id = roomTime[0];

  String _name = roomTime[1];

  String _mobileNo = roomTime[2];

  int _startDateDay = int.parse(roomTime[3].split('/')[0]);
  int _startDateMonth = int.parse(roomTime[3].split('/')[1]);
  int _startDateYear = int.parse(roomTime[3].split('/')[2]);
  DateTime _startDate = DateTime(_startDateYear, _startDateMonth, _startDateDay);

  int _startHour = int.parse(roomTime[4].split(':')[0]);
  int _startMinute = int.parse(roomTime[4].split(':')[1]);
  TimeOfDay _startTime = TimeOfDay(hour: _startHour, minute: _startMinute);

  int _endDateDay = int.parse(roomTime[5].split('/')[0]);
  int _endDateMonth = int.parse(roomTime[5].split('/')[1]);
  int _endDateYear = int.parse(roomTime[5].split('/')[2]);
  DateTime _endDate = DateTime(_endDateYear, _endDateMonth, _endDateDay);

  int _endHour = int.parse(roomTime[6].split(':')[0]);
  int _endMinute = int.parse(roomTime[6].split(':')[1]);
  TimeOfDay _endTime = TimeOfDay(hour: _endHour, minute: _endMinute);

  String _status = roomTime[7];

  String _purpose = roomTime[8];

  return RoomTime(id: _id, name: _name, mobileNo: _mobileNo, startDate: _startDate, startTime: _startTime, endDate: _endDate, endTime: _endTime, status: _status, purpose: _purpose);
}

List<RoomTime> customizeTimeDataList (List roomTime) {
  List<RoomTime> roomTimes = [];

  if (roomTime == []) {
    return roomTimes;
  } else {
    roomTime.forEach((time) {
      roomTimes.add(customizeTimeData(time));
    });
    return roomTimes;
  }
}

List<RoomTime> searchForCurrentBookedRoomTimes (List<RoomTime> roomTimes) {
  List<RoomTime> currentRoomTimes = [];
  DateTime currentTime = DateTime.now();

  if (roomTimes == []) {
    return currentRoomTimes;
  } else {
    roomTimes.forEach((RoomTime time) {
      if (time.status == '-') {
        DateTime _endTime = DateTime(time.endDate.year, time.endDate.month, time.endDate.day, time.endTime.hour, time.endTime.minute);
        if (_endTime.isAfter(currentTime)) {
          currentRoomTimes.add(time);
        }
      }
    });
    return currentRoomTimes;
  }
}

bool isNotFinished (RoomTime time) {
  DateTime _currentTime = DateTime.now();
  DateTime _endTime = DateTime(time.endDate.year, time.endDate.month, time.endDate.day, time.endTime.hour, time.endTime.minute);
  if (_endTime.isAfter(_currentTime)) {
    return true;
  } else {
    return false;
  }
}


