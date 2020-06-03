import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:http/http.dart' as http;
import 'package:instiapp/utilities/constants.dart';

class RoomService extends StatefulWidget {
  @override
  _RoomServiceState createState() => _RoomServiceState();
}

List<Room> rooms = [];
String userID = gSignIn.currentUser.email;

bool loading = true;
List<ItemModelComplex> blocks = [];
List<YourRoom> userRooms;

class _RoomServiceState extends State<RoomService> {

  Map<String, List<Room>> allBlocks = {};

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  getRooms () async {
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
      blocks.add(ItemModelComplex(header: block, bodyModel: rooms, timesOfRooms: makeItemModelSimple(rooms)));
    });

    setState(() {
      loading = false;
    });
  }

  List<ItemModelSimple> makeItemModelSimple (List<Room> rooms) {
    List<ItemModelSimple> timesOfRooms = [];
    if (rooms.length == 0) {
      return timesOfRooms;
    } else {
      rooms.forEach((Room room) {
        timesOfRooms.add(ItemModelSimple(header: 'Booked Time Slots', bodyModel: room.bookedslots));
      });
      return timesOfRooms;
    }
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
                    '${room.roomno}',
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
                content: Text('Booked by: ${time.name}, Mobile no.: ${time.mobNo}'),
              ),
            );
          },
          icon: Icon(
            Icons.person_outline,
          ),
          label: Flexible(
              child: Text('${time.start.day}/${time.start.month}/${time.start.year}  ${time.start.hour}:${time.start.minute} - ${time.end.day}/${time.end.month}/${time.end.year}  ${time.end.hour}:${time.end.minute}')),
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
        itemCount: allBlocks.length,
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
      room.bookedslots.forEach((RoomTime time){
        if (time.userId == userID ) {
          yourRooms.add(YourRoom(roomId: room.roomId, userId: time.userId, block: room.block, roomNo: room.roomno, start: time.start,  end: time.end, purpose: time.purpose));
        }
      });
    });

    return yourRooms;
  }

  cancelRoom (YourRoom yourRoom) {
    //TODO: IMPLEMENT CANCEL
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
                        Text('${room.start.day}/${room.start.month}/${room.start.year}  ${room.start.hour}:${room.start.minute}'),
                        SizedBox(height: 5,),
                        Text('To'),
                        SizedBox(height: 5,),
                        Text('${room.end.day}/${room.end.month}/${room.end.year}  ${room.end.hour}:${room.end.minute}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: (loading == true)
            ? Center(child: CircularProgressIndicator())
            : homeScreen()
    );
  }
}







