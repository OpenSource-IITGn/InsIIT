import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';

class Room{
  String roomId;
  String block;
  String roomno;
  String capacity;
  String roomType;
  String description;
  List<RoomTime> bookedslots;

  Room({this.roomId,this.block,this.roomno,this.capacity,this.roomType,this.description,this.bookedslots});

  factory Room.fromJson(Map<String, dynamic> json){

    List <RoomTime> bookedTimes = [];
    List<dynamic> users = json['booked_slots'];
    int noOfBookings = users.length;
    for(int i=0; i<noOfBookings;i++){
      bookedTimes.add(RoomTime.fromJson(users[i]));
    }
    return Room(
      roomId: json['_id'],
      block : json['block'],
      roomno: json['room_number'],
      capacity: json['capacity'],
      roomType: json['room_type'],
      description: json['description'],
      bookedslots: bookedTimes,
    );
  }
}

class RoomTime{
  String userId;
  String name;
  String mobNo;
  String bio;
  DateTime start;
  DateTime end;
  String purpose;
  String url;
  String bookingId;

  RoomTime({this.userId,this.name,this.mobNo,this.bio,this.start,this.end,this.purpose,this.url, this.bookingId});

  factory RoomTime.fromJson(Map<String, dynamic> json){
    return RoomTime(
        userId: json['booked_by']['user_id'],
        name: json['booked_by']['full_name'],
        mobNo: json['booked_by']['contact'].toString(),
        bio: json['booked_by']['bio'],
        start: DateTime.fromMillisecondsSinceEpoch(json['start']),
        end: DateTime.fromMillisecondsSinceEpoch(json['end']),
        purpose: json['purpose'],
        url: json['booked_by']['image_link'],
        bookingId: json['booking_id']
    );
  }

}

class YourRoom{
  String userId;
  String roomId;
  String block;
  String roomNo;
  DateTime start;
  DateTime end;
  String purpose;
  String bookingID;

  YourRoom({this.userId, this.roomId,this.block,this.roomNo, this.start, this.end, this.purpose, this.bookingID});

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
  if (userTime.end.isBefore(roomTime.start)){
    return false;
  } else if(userTime.start.isAfter(roomTime.end)){
    return false;
  } else{
    return true;
  }

}



List<RoomTime> searchForCurrentBookedRoomTimes (List<RoomTime> roomTimes) {
  List<RoomTime> currentRoomTimes = [];
  DateTime currentTime = DateTime.now();

  if (roomTimes == []) {
    return currentRoomTimes;
  } else {
    roomTimes.forEach((RoomTime time) {
      DateTime _endTime = time.end;
      if(_endTime.isAfter(currentTime)){
        currentRoomTimes.add(time);
      }
    });
    return currentRoomTimes;
  }
}

bool isNotFinished (RoomTime time) {
  DateTime _currentTime = DateTime.now();
  DateTime _endTime = time.end;
  if (_endTime.isAfter(_currentTime)) {
    return true;
  } else {
    return false;
  }
}


