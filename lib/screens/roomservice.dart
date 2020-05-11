import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/screens/functions.dart';
import 'package:instiapp/utilities/constants.dart';

class RoomService extends StatefulWidget {
  @override
  _RoomServiceState createState() => _RoomServiceState();
}

GSheet sheet = GSheet('1ubVLWH6bY4xcS9xXGTPxUbpcy96ZbQLhyonL3TY7tXs');

List<Room> rooms;
String userID = gSignIn.currentUser.email;

dynamic dataList;
Future<dynamic> data;
List r7101;
List r7102;
List r1101;
List r6202;
List r6203;


class _RoomServiceState extends State<RoomService> {

  List<ItemModelComplex> blocks;

  List<Room> block1 = [];
  List<Room> block2 = [];
  List<Room> block3 = [];
  List<Room> block4 = [];
  List<Room> block5 = [];
  List<Room> block6 = [];
  List<Room> block7 = [];

  List<YourRoom> userRooms;

  @override
  void initState() {
    super.initState();
    data = loadData();
  }

  loadData() async{
    dataList = [await sheet.getDataOnline('7/101!A:I'), await sheet.getDataOnline('7/102!A:I'), await sheet.getDataOnline('1/101!A:I'), await sheet.getDataOnline('6/202!A:I'), await sheet.getDataOnline('6/203!A:I')];
    r7101 = dataList[0];
    r7102 = dataList[1];
    r1101 = dataList[2];
    r6202 = dataList[3];
    r6203 = dataList[4];
    rooms = [
      Room(block: '7', room: '101',capacity: '40', roomType: 'Classroom', facility: '-', bookedTimes: customizeTimeDataList(makeTimeList(r7101))),
      Room(block: '7', room: '102',capacity: '50', roomType: 'Classroom', facility: '-', bookedTimes: customizeTimeDataList(makeTimeList(r7102))),
      Room(block: '1', room: '101', capacity: '150', roomType: 'Classroom', facility: 'Air condition, Audio system, Furniture, Projector', bookedTimes: customizeTimeDataList(makeTimeList(r1101))),
      Room(block: '6', room: '202', capacity: '50', roomType: 'Classroom', facility: '-', bookedTimes: customizeTimeDataList(makeTimeList(r6202))),
      Room(block: '6', room: '203', capacity: '25', roomType: 'Meeting room', facility: '-', bookedTimes: customizeTimeDataList(makeTimeList(r6203))),
    ];
    userRooms = makeListOfYourRooms(rooms);
    makeOccupiedRoomsList(rooms);
    blocks = [
      ItemModelComplex(header: 'Block 1', bodyModel: block1, timesOfRooms: makeItemModelSimple(block1)),
      ItemModelComplex(header: 'Block 2', bodyModel: block2, timesOfRooms: makeItemModelSimple(block2)),
      ItemModelComplex(header: 'Block 3', bodyModel: block3, timesOfRooms: makeItemModelSimple(block3)),
      ItemModelComplex(header: 'Block 4', bodyModel: block4, timesOfRooms: makeItemModelSimple(block4)),
      ItemModelComplex(header: 'Block 5', bodyModel: block5, timesOfRooms: makeItemModelSimple(block5)),
      ItemModelComplex(header: 'Block 6', bodyModel: block6, timesOfRooms: makeItemModelSimple(block6)),
      ItemModelComplex(header: 'Block 7', bodyModel: block7, timesOfRooms: makeItemModelSimple(block7)),
    ];
    return dataList;
  }

  List<ItemModelSimple> makeItemModelSimple (List<Room> rooms) {
    List<ItemModelSimple> timesOfRooms = [];
    if (rooms.length == 0) {
      return timesOfRooms;
    } else {
      rooms.forEach((Room room) {
        timesOfRooms.add(ItemModelSimple(header: 'Booked Time Slots', bodyModel: room.bookedTimes));
      });
      return timesOfRooms;
    }
  }

  addToBlock(Room room) {
    if (room.block == '1') {
      block1.add(room);
    } else if (room.block == '2') {
      block2.add(room);
    } else if (room.block == '3') {
      block3.add(room);
    } else if (room.block == '4') {
      block4.add(room);
    } else if (room.block == '5') {
      block5.add(room);
    } else if (room.block == '6') {
      block6.add(room);
    } else if (room.block == '7') {
      block7.add(room);
    }
  }

  makeOccupiedRoomsList (List<Room> rooms) {
    rooms.forEach((room) {
      List<RoomTime> _bookedTimes = searchForCurrentBookedRoomTimes(room.bookedTimes);
      if (_bookedTimes.length != 0) {
        Room _room = Room(block: room.block, room: room.room, capacity: room.capacity, roomType: room.roomType, facility: room.facility, bookedTimes: _bookedTimes);
        addToBlock(_room);
      }
    });
  }

  Widget showBookedTimeSlots (int blockIndex, int roomIndex) {
    return ExpansionPanelList(
      expansionCallback: (int item, bool status) {
        setState(() {
          blocks[blockIndex].timesOfRooms[roomIndex].isExpanded = !blocks[blockIndex].timesOfRooms[roomIndex].isExpanded;
        });
      },
      animationDuration: Duration(seconds: 1),
      children: [
        ExpansionPanel(
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: timeBody(blocks[blockIndex].timesOfRooms[roomIndex].bodyModel),
          ),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return timeHeader(blocks[blockIndex].timesOfRooms[roomIndex].header);
          },
          isExpanded: blocks[blockIndex].timesOfRooms[roomIndex].isExpanded,
        ),
      ],
    );
  }

  Widget roomsDetail (List<Room> rooms, int index) {
    if (rooms.length != 0) {
      return Column(
        children: rooms.asMap().entries.map<Widget>((entry) {
          int i = entry.key;
          Room room = entry.value;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${room.block}/${room.room}',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text('${room.roomType} Capacity: ${room.capacity}'),
                  SizedBox(height: 8,),
                  showBookedTimeSlots(index, i),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Center(
        child: Text(
          'All rooms are available.',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }
  }

  Widget timeHeader (name) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget timeBody (List<RoomTime> times) {
    return Column(
      children: times.map<Widget>((time) {
        return FlatButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                content: Text('Booked by: ${time.name}, Mobile no.: ${time.mobileNo}'),
              ),
            );
          },
          icon: Icon(
            Icons.person_outline,
          ),
          label: Flexible(
              child: Text('${time.startDate.day}/${time.startDate.month}/${time.startDate.year}  ${time.startTime.hour}:${time.startTime.minute} - ${time.endDate.day}/${time.endDate.month}/${time.endDate.year}  ${time.endTime.hour}:${time.endTime.minute}')),
        );
      }).toList(),
    );
  }

  Widget blockHead (name) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget occupiedRooms () {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionPanelList(
            expansionCallback: (int item, bool status) {
              setState(() {
                blocks[index].isExpanded = !blocks[index].isExpanded;
              });
            },
            animationDuration: Duration(seconds: 1),
            children: [
              ExpansionPanel(
                body: Container(
                  padding: EdgeInsets.all(15.0),
                  child: roomsDetail(blocks[index].bodyModel, index),
                ),
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return blockHead(blocks[index].header);
                },
                isExpanded: blocks[index].isExpanded,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget logoWidget() {
    return Container(
      height: 1720,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/TL2.gif',
              //'http://students.iitgn.ac.in/Tinkerers_Lab/images/TL2.png',
              height: 410,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget machineWidget(String link) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        child: Stack(
          children: <Widget>[
            Image(
              image: NetworkImage(link),
              height: 500,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }

  Widget tinkerersLab () {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          logoWidget(),
          Positioned(
            bottom: 840,
            child: machineWidget('https://bizimages.withfloats.com/actual/5c2de30bde86d10001d07ae4.jpg'),
          ),
          Positioned(
            bottom: 430,
            child: machineWidget('http://students.iitgn.ac.in/Tinkerers_Lab/images/3dprinter.png'),
          ),
          Positioned(
            bottom: 0,
            child: machineWidget('https://i.dlpng.com/static/png/3920770-roland-gr-540-camm-1-vinyl-cutter-plotter-grant-graphics-png-vinyl-cutters-720_720_preview.webp'),
          ),
        ],
      ),
    );
  }

  List<YourRoom> makeListOfYourRooms (List<Room> rooms){
    List<YourRoom> yourRooms = [];

    rooms.forEach((Room room){
      room.bookedTimes.forEach((RoomTime time){
        if (time.id == gSignIn.currentUser.email && time.status == '-' && isNotFinished(time)) {
          yourRooms.add(YourRoom(id: time.id, block: room.block, roomNo: room.room, startDate: time.startDate, startTime: time.startTime, endDate: time.endDate, endTime: time.endTime, purpose: time.purpose));
        }
      });
    });

    return yourRooms;
  }

  cancelRoom (YourRoom yourRoom) {
    String sheetName = '${yourRoom.block}/${yourRoom.roomNo}';
    rooms.forEach((Room room) {
      if (room.block == yourRoom.block && room.room == yourRoom.roomNo) {
        room.bookedTimes.asMap().forEach((int index, RoomTime time) {
          if (time.id == yourRoom.id && time.startDate == yourRoom.startDate && time.startTime == yourRoom.startTime && time.endDate == yourRoom.endDate && time.endTime == yourRoom.endTime && time.status == '-') {
            int i = index + 2;
            sheet.updateData([['cancelled']],'$sheetName!H$i:H$i');
          }
        });
      }
    });
  }

  Widget yourRoomCard(YourRoom room){
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('${room.block}/${room.roomNo}'),
                    SizedBox(width: 15,),
                    verticalDivider(),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${room.startDate.day}/${room.startDate.month}/${room.startDate.year}  ${room.startTime.hour}:${room.startTime.minute}'),
                        SizedBox(height: 5,),
                        Text('To'),
                        SizedBox(height: 5,),
                        Text('${room.endDate.day}/${room.endDate.month}/${room.endDate.year}  ${room.endTime.hour}:${room.endTime.minute}'),
                      ],
                    ),
                    SizedBox(width: 15,),
                    verticalDivider(),
                    SizedBox(width: 15,),
                    Flexible(
                      child: Text('${room.purpose}'),
                    ),
                  ],
                ),
                FlatButton.icon(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Container(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Do you want to cancel this booking?'),
                              SizedBox(height: 5,),
                              FlatButton(
                                onPressed: () {
                                  cancelRoom(room);
                                  Navigator.pushReplacementNamed(context, '/RoomBooking');
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.cancel,
                  ),
                  label: Text('Cancel Booking'),
                )
              ],
            ),
          ),
        )
    );
  }

  Widget mapYourRooms () {
    if (userRooms.length == 0) {
      return Center(
        child: Text('You have not booked any rooms.'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: userRooms.map<Widget>((YourRoom room){
            return yourRoomCard(room);
          }).toList(),
        ),
      );
    }
  }

  Widget yourRooms () {
    return Scaffold(
      body: mapYourRooms(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/selecttime');
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget homeScreen () {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Room Booking'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
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
                Icons.short_text,
                color: Colors.white,
                size: 38,
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: 'Your Rooms'),
                Tab(text: 'Occupied Rooms'),
                Tab(text: 'Tinkerers Lab',)
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            yourRooms(),
            occupiedRooms(),
            SingleChildScrollView(child: tinkerersLab()),
          ],
        ),
      ),
    );
  }

  Widget loadScreen () {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Room Booking'),
        centerTitle: true,
      ),
      body: Center(
        child: SpinKitChasingDots(
          color: Colors.indigo,
          size: 50.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([data]),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loadScreen();
          case ConnectionState.waiting:
            return loadScreen();
          case ConnectionState.done:
            return homeScreen();
          default:
            return loadScreen();
        }
      },
    );
  }
}

verticalDivider() {
  return Row(
    children: <Widget>[
      SizedBox(
        width: 16,
      ),
      Container(
        height: 50,
        width: 1,
        color: Colors.grey,
      ),
      SizedBox(
        width: 16,
      ),
    ],
  );
}





