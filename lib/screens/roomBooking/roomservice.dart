import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:http/http.dart' as http;
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/homePage.dart';

class RoomService extends StatefulWidget {
  @override
  _RoomServiceState createState() => _RoomServiceState();
}

List<Room> rooms = [];
String userID = gSignIn.currentUser.email;

class _RoomServiceState extends State<RoomService> {
  bool loading = true;
  List<ItemModelComplex> blocks = [];
  List<YourRoom> userRooms;

  Map<String, List<Room>> allBlocks = {};

  @override
  void initState() {
    super.initState();
    rooms = [];
    getRooms();
  }

  getRooms() async {
    setState(() {
      loading = true;
    });
    var queryParameters = {
      'api_key': 'NIKS',
    };
    var uri = Uri.https(baseUrl, '/getRoomsBookings', queryParameters);
    print("PINGING:" + uri.toString());
    var response = await http.get(uri);
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    for (int i = 0; i < responseJson['results'].length; i++) {
      Room room = Room.fromJson(responseJson['results'][i]);
      rooms.add(room);
      if (allBlocks.containsKey(room.block)) {
        allBlocks[room.block].add(room);
      } else {
        allBlocks.putIfAbsent(room.block, () => [room]);
      }
    }

    userRooms = makeListOfYourRooms(rooms);

    allBlocks.forEach((String block, List<Room> rooms) {
      blocks.add(ItemModelComplex(
          header: block,
          bodyModel: rooms,
          timesOfRooms: makeItemModelSimple(rooms)));
    });

    setState(() {
      loading = false;
    });
  }

  List<ItemModelSimple> makeItemModelSimple(List<Room> rooms) {
    List<ItemModelSimple> timesOfRooms = [];
    if (rooms.length == 0) {
      return timesOfRooms;
    } else {
      rooms.forEach((Room room) {
        timesOfRooms.add(ItemModelSimple(
            header: 'Booked Time Slots', bodyModel: room.bookedslots));
      });
      return timesOfRooms;
    }
  }

  Widget showBookedTimeSlots(int blockIndex, int roomIndex) {
    return ExpansionTile(
      title: timeHeader(blocks[blockIndex].timesOfRooms[roomIndex].header),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15.0),
          child: timeBody(blocks[blockIndex].timesOfRooms[roomIndex].bodyModel),
        ),
      ],
    );
  }

  Widget roomsDetail(List<Room> rooms, int index, roomdetail) {
    if (rooms.length != 0) {
      return Column(
        children: rooms.asMap().entries.map<Widget>((entry) {
          int i = entry.key;
          Room room = entry.value;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ExpansionTile(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'AB-${roomdetail.split(' ')[2]}/${room.roomno}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Capacity: ${room.capacity}',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black.withAlpha(150),
                      )),
                ],
              ),
              children: [timeBody(blocks[index].timesOfRooms[i].bodyModel)],
            ),
          );
        }).toList(),
      );
    } else {
      return Center(
        child: Text(
          'No rooms are available.',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }
    // if (rooms.length != 0) {
    //   return Column(
    //     children: rooms.asMap().entries.map<Widget>((entry) {
    //       int i = entry.key;
    //       Room room = entry.value;
    //       return Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: <Widget>[
    //             Text(
    //               '${room.roomno}',
    //               style: TextStyle(
    //                 fontSize: 17.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 8,
    //             ),
    //             Text('${room.roomType} Capacity: ${room.capacity}'),
    //             SizedBox(
    //               height: 8,
    //             ),

    //           ],
    //         ),
    //       );
    //     }).toList(),
    //   );
    // } else {
    //   return Center(
    //     child: Text(
    //       'All rooms are available.',
    //       style: TextStyle(
    //         color: Colors.black,
    //       ),
    //     ),
    //   );
    // }
    // showBookedTimeSlots(index, i),
  }

  Widget timeHeader(name) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        name,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget timeBody(List<RoomTime> times) {
    if (times.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Room is free!"),
      );
    }
    return Column(
      children: times.map<Widget>((time) {
        return FlatButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                content:
                    Text('Booked by: ${time.name}, Mobile no.: ${time.mobNo}'),
              ),
            );
          },
          icon: Icon(
            Icons.person_outline,
          ),
          label: Flexible(
              child: Text(
                  '${time.start.day}/${time.start.month}/${time.start.year}  ${time.start.hour}:${time.start.minute} - ${time.end.day}/${time.end.month}/${time.end.year}  ${time.end.hour}:${time.end.minute}')),
        );
      }).toList(),
    );
  }

  Widget blockHead(name) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.black,
          // fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget occupiedRooms() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: allBlocks.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: blockHead(blocks[index].header),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: roomsDetail(
                    blocks[index].bodyModel, index, blocks[index].header),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget logoWidget() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        child: Image.asset(
          'assets/images/TL2.gif',
          //'http://students.iitgn.ac.in/Tinkerers_Lab/images/TL2.png',
          // height: 410,
          // width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget machineWidget(String link) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Image.asset(
        link,
        //'http://students.iitgn.ac.in/Tinkerers_Lab/images/TL2.png',
        // height: 410,

        // width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget tinkerersLab() {
    //add better pics
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            logoWidget(),
            machineWidget('assets/images/3dprinter.png'),
            machineWidget('assets/images/3dprinter.png'),
            machineWidget('assets/images/3dprinter.png'),
          ],
        ),
      ),
    );
  }

  List<YourRoom> makeListOfYourRooms(List<Room> rooms) {
    List<YourRoom> yourRooms = [];

    rooms.forEach((Room room) {
      room.bookedslots.forEach((RoomTime time) {
        if (time.userId == userID) {
          yourRooms.add(YourRoom(
              roomId: room.roomId,
              userId: time.userId,
              block: room.block,
              roomNo: room.roomno,
              start: time.start,
              end: time.end,
              purpose: time.purpose,
              bookingID: time.bookingId));
        }
      });
    });

    return yourRooms;
  }

  cancelRoom(YourRoom yourRoom) async {
    var queryParameters = {
      'api_key': 'NIKS',
      'booking_id': yourRoom.bookingID,
      'room_id': yourRoom.roomId
    };
    var uri = Uri.https(baseUrl, '/deleteBooking', queryParameters);
    print("PINGING:" + uri.toString());
    Navigator.pop(context);
    loading = true;
    setState(() {});
    var response = await http.get(uri);
    loading = false;
    print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
    selectedIndex = 4;
    // Navigator.pop(context);
    setState(() {});
  }

  Widget yourRoomCard(YourRoom room) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: ScreenSize.size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'AB-${room.block.split(' ')[2]}/${room.roomNo}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    (room.start.day == room.end.day)
                        ? Text(
                            '${room.start.hour.toString().padLeft(2, '0')}:${room.start.minute.toString().padLeft(2, '0')} to ${room.end.hour.toString().padLeft(2, '0')}:${room.end.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(150),
                            ))
                        : Container(),
                    (room.start.day == room.end.day)
                        ? Text(
                            '${room.start.day.toString().padLeft(2, '0')}/${room.start.month.toString().padLeft(2, '0')}/${room.end.year.toString()} ',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(150),
                            ))
                        : Container(),
                    (room.start.day == room.end.day)
                        ? Container()
                        : Text(
                            '${room.end.day.toString().padLeft(2, '0')}/${room.end.month.toString().padLeft(2, '0')}  ${room.end.hour.toString().padLeft(2, '0')}:${room.end.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black.withAlpha(150),
                            )),
                    (room.start.day != room.end.day)
                        ? Text(
                            '${room.end.hour.toString().padLeft(2, '0')}:${room.end.minute.toString().padLeft(2, '0')} (${room.end.day.toString().padLeft(2, '0')}/${room.end.month.toString().padLeft(2, '0')}) to ${room.end.hour.toString().padLeft(2, '0')}:${room.end.minute.toString().padLeft(2, '0')}(${room.start.day.toString().padLeft(2, '0')}/${room.start.month.toString().padLeft(2, '0')})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black.withAlpha(150),
                            ))
                        : Container(),
                    Text('Purpose: ${room.purpose}',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.black.withAlpha(150),
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            cancelRoom(room);
                          },
                          child: Text('Yes'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                      ],
                      content: Text('Do you want to cancel this booking?'),
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget mapYourRooms() {
    if (userRooms.length == 0) {
      return Center(
        child: Text('Book a room by pressing the + button!'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: userRooms.map<Widget>((YourRoom room) {
            return yourRoomCard(room);
          }).toList(),
        ),
      );
    }
  }

  Widget yourRooms() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: mapYourRooms(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "fab1rs",
            onPressed: null,
            backgroundColor: Colors.white,
            child: PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: '/tlemergencycontacts',
                  child: Text("Emergency Contacts"),
                ),
                PopupMenuItem(
                  value: '/tlcourseaccessrequest',
                  child: Text("Course Access Request"),
                ),
                PopupMenuItem(
                  value: '/tllabaccessforworkshop',
                  child: Text("Lab Access For Workshop"),
                ),
                PopupMenuItem(
                  value: '/tlinventoryaccess',
                  child: Text("Inventory Access"),
                ),
              ],
              onSelected: (value) {
                // Navigator.pushNamed(context, value);
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black,
                // size: 38,
              ),
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "fab2rs",
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/selecttime').then((value) => setState((){rooms = [];
    getRooms();
    }));
            },
            child: Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget homeScreen() {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   backgroundColor: primaryColor,
          //   title: Text('Room Booking'),
          //   centerTitle: true,
          //   actions: <Widget>[],
          // ),
          body: Container(
            height: ScreenSize.size.height,
            width: ScreenSize.size.width,
            child: Column(
              children: <Widget>[
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black.withOpacity(0.3),
                  indicatorColor: Colors.black,
                  tabs: <Widget>[
                    Tab(text: 'Your Rooms'),
                    Tab(text: 'Occupied Rooms'),
                    Tab(
                      text: 'Tinkerers Lab',
                    )
                  ],
                ),
                Container(
                  // color: Colors.black,
                  height: MediaQuery.of(context).size.height - 200,
                  width: ScreenSize.size.width,
                  child: TabBarView(
                    children: <Widget>[
                      yourRooms(),
                      occupiedRooms(),
                      SingleChildScrollView(child: tinkerersLab()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: (loading == true)
            ? Center(child: CircularProgressIndicator())
            : homeScreen());
  }
}