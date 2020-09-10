/*(beta)class Room{
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
        start: DateTime.fromMillisecondsSinceEpoch((json['start'] is int) ? json['start'] : int.parse(json['start'])),
        end: DateTime.fromMillisecondsSinceEpoch((json['end'] is int) ? json['end'] : int.parse(json['end'])),
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

bool timeClashMachine(MachineTime userTime, MachineTime machineTime) {
  if (userTime.end.isBefore(machineTime.start)){
    return false;
  } else if(userTime.start.isAfter(machineTime.end)){
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

class Machine {

  String machineId;
  String type;
  String model;
  String tier;
  String machineImgUrl;
  List<dynamic> allowedExtensions;
  List<RoomTime> bookedslots;
  List<MachineTime> bookedSlotsWithFiles;

  Machine({this.machineId, this.type, this.model, this.tier, this.machineImgUrl, this.allowedExtensions, this.bookedslots, this.bookedSlotsWithFiles});

  factory Machine.fromJson(Map<String, dynamic> json){

    List <RoomTime> bookedTimes = [];
    List<dynamic> users = json['booked_slots'];
    int noOfBookings = users.length;
    for(int i=0; i<noOfBookings;i++){
      bookedTimes.add(RoomTime.fromJson(users[i]));
    }

    List <MachineTime> bookedTimesWithFiles = [];
    for(int i=0; i<noOfBookings;i++){
      bookedTimesWithFiles.add(MachineTime.fromJson(users[i]));
    }
    return Machine(
        machineId: json['_id'],
        type : json['type'],
        model: json['model'],
        tier: json['tier'],
        machineImgUrl: json['machine_img_url'],
        allowedExtensions: json['allowed_extensions'],
        bookedslots: bookedTimes,
        bookedSlotsWithFiles: bookedTimesWithFiles
    );
  }
}

class MachineTime{
  String userId;
  String name;
  String mobNo;
  String bio;
  DateTime start;
  DateTime end;
  String purpose;
  String url;
  List<String> urlOfUploadedFiles;
  String bookingId;

  MachineTime({this.userId,this.name,this.mobNo,this.bio,this.start,this.end,this.purpose,this.url,this.urlOfUploadedFiles, this.bookingId});

  factory MachineTime.fromJson(Map<String, dynamic> json){
    return MachineTime(
        userId: json['booked_by']['user_id'],
        name: json['booked_by']['full_name'],
        mobNo: json['booked_by']['contact'].toString(),
        bio: json['booked_by']['bio'],
        start: DateTime.fromMillisecondsSinceEpoch((json['start'] is int) ? json['start'] : int.parse(json['start'])),
        end: DateTime.fromMillisecondsSinceEpoch((json['end'] is int) ? json['end'] : int.parse(json['end'])),
        purpose: json['purpose'],
        url: json['booked_by']['image_link'],
        urlOfUploadedFiles: json['booked_by']['file_links'],
        bookingId: json['booking_id']
    );
  }

}


class YourBookedMachine {

  String userId;
  String machineId;
  String type;
  String model;
  String tier;
  DateTime start;
  DateTime end;
  String purpose;
  String bookingId;

  YourBookedMachine({this.userId, this.machineId, this.type, this.model, this.tier, this.start, this.end, this.purpose, this.bookingId});
}*/


