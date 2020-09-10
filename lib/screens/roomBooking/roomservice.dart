/*(beta)import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:http/http.dart' as http;
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/TLForms/TLContactPage.dart';
import 'package:instiapp/classes/tlclass.dart';

class RoomService extends StatefulWidget {
  @override
  _RoomServiceState createState() => _RoomServiceState();
}

List<Room> rooms = [];
String userID = (guest) ? 'Guest' : firebaseUser.email;
List<Machine> machines = [];
List<dynamic> emailIds = [];
List<Tinkerer> inventory = [] ;
List<Tinkerer> labAccess = [];
List<Tinkerer> courseAccess = [];
class _RoomServiceState extends State<RoomService>
    with AutomaticKeepAliveClientMixin<RoomService> {
  String bookingTitle = 'Rooms';
  bool loading = true;
  bool loadingMachines = true;
  List<ItemModelComplex> blocks = [];
  List<Widget> machineTypes = [];
  List<YourRoom> userRooms = [];
  List<YourBookedMachine> userBookedMachines = [];
  int noOfMachines;

  Map<String, List<Room>> allBlocks = {};
  Map<String, List<Machine>> allMachines = {};

  @override
  void initState() {
    super.initState();
    rooms = [];
    if (!guest) {
      getRooms();
      getMachines();
      makeTLDataList();
    }
  }
  void makeTLDataList(){
    tlDataList.forEach((Tinkerer time) {
      time.job.forEach((i) {
        if(i == 'Lab Access'){
          labAccess.add(time);
        }
        else if(i == 'Inventory Access'){
          inventory.add(time);
        }
        else if(i == 'Course Access'){
          courseAccess.add(time);
        }
      });

    });
  }

  getRooms() async {
    allBlocks = {};
    blocks = [];
    rooms = [];
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

  getMachines() async {
    allMachines = {};
    setState(() {
      loadingMachines = true;
    });
    machines = [];

    var queryParameters = {
      'api_key': 'GULLU',
    };
    var uri = Uri.https(baseUrlTL, '/getMachines', queryParameters);
    print("PINGING:" + uri.toString());
    var response = await http.get(uri);
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    for (int i = 0; i < responseJson['results'].length; i++) {
      Machine machine = Machine.fromJson(responseJson['results'][i]);
      machines.add(machine);
      if (allMachines.containsKey(machine.type)) {
        allMachines[machine.type].add(machine);
      } else {
        allMachines.putIfAbsent(machine.type, () => [machine]);
      }
    }

    noOfMachines = allMachines.length;
    allMachines.forEach((String type, List<Machine> machines) {
      machineTypes.add(machineWidget(type, machines));
    });

    userBookedMachines = makeListOfYourBookedMachines(machines);
    setState(() {
      loadingMachines = false;
    });
    print('Got machines');
  }

  void refreshMachineTypes() {
    machineTypes = [];
    allMachines.forEach((String type, List<Machine> machines) {
      machineTypes.add(machineWidget(type, machines));
    });
  }

  List<ItemModelSimple> makeItemModelSimple(List<Room> rooms) {
    List<ItemModelSimple> timesOfRooms = [];
    if (rooms.length == 0) {
      return timesOfRooms;
    } else {
      rooms.forEach((Room room) {
        List<RoomTime> bookedSlots = [];
        room.bookedslots.forEach((RoomTime time) {
          if (time.end.isAfter(DateTime.now()) &&
              time.start.isBefore(DateTime.now())) {
            bookedSlots.add(time);
          }
        });
        timesOfRooms.add(ItemModelSimple(
            header: 'Booked Time Slots', bodyModel: bookedSlots));
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
      height: 170,
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

  Widget machineWidget(String type, List<Machine> machines) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/firstPage', arguments: {
          'type': type,
          'machines': machines,
        }).then((value) => setState(() {
              machines = [];
              getMachines();
            }));
      },
      child: Card(
        child: Container(
            width: MediaQuery.of(context).size.width,
            // height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: machines[0].machineImgUrl,
                    width: ScreenSize.size.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                  OutlineButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: null,
                    child: Text('Book ' + type,
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget tinkerersLab() {
    refreshMachineTypes();
    //add better pics
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            // logoWidget(),
            Column(
              children: machineTypes,
            ),
//            machineWidget('assets/images/3dprinter.png'),
//            machineWidget('assets/images/3dprinter.png'),
          ],
        ),
      ),
    );
  }

  List<YourRoom> makeListOfYourRooms(List<Room> rooms) {
    List<YourRoom> yourRooms = [];

    rooms.forEach((Room room) {
      room.bookedslots.forEach((RoomTime time) {
        if (time.userId == userID && time.end.isAfter(DateTime.now())) {
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

  List<YourBookedMachine> makeListOfYourBookedMachines(List<Machine> machines) {
    List<YourBookedMachine> yourBookedMachines = [];

    machines.forEach((Machine machine) {
      machine.bookedslots.forEach((RoomTime time) {
        if (time.userId == userID && time.end.isAfter(DateTime.now())) {
          yourBookedMachines.add(YourBookedMachine(
              machineId: machine.machineId,
              userId: time.userId,
              type: machine.type,
              model: machine.model,
              tier: machine.tier,
              start: time.start,
              end: time.end,
              purpose: time.purpose,
              bookingId: time.bookingId));
        }
      });
    });

    return yourBookedMachines;
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
    print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
    setState(() {
      getRooms();
    });
  }

  cancelMachine(YourBookedMachine machine) async {
    var queryParameters = {
      'api_key': 'GULLU',
      'machine_id': machine.machineId,
      'booking_id': machine.bookingId
    };
    var uri = Uri.https(baseUrlTL, '/deleteBooking', queryParameters);
    print("PINGING:" + uri.toString());
    Navigator.pop(context);
    loadingMachines = true;
    setState(() {});
    var response = await http.get(uri);
    loadingMachines = false;
    print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
    setState(() {
      getMachines();
    });
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
                width: ScreenSize.size.width * 0.6,
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
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget yourBookedMachineCard(YourBookedMachine machine) {
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
                width: ScreenSize.size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      machine.type,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      machine.model,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    (machine.start.day == machine.end.day)
                        ? Text(
                            '${machine.start.hour.toString().padLeft(2, '0')}:${machine.start.minute.toString().padLeft(2, '0')} to ${machine.end.hour.toString().padLeft(2, '0')}:${machine.end.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(150),
                            ))
                        : Container(),
                    (machine.start.day == machine.end.day)
                        ? Text(
                            '${machine.start.day.toString().padLeft(2, '0')}/${machine.start.month.toString().padLeft(2, '0')}/${machine.end.year.toString()} ',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withAlpha(150),
                            ))
                        : Container(),
                    (machine.start.day == machine.end.day)
                        ? Container()
                        : Text(
                            '${machine.end.day.toString().padLeft(2, '0')}/${machine.end.month.toString().padLeft(2, '0')}  ${machine.end.hour.toString().padLeft(2, '0')}:${machine.end.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black.withAlpha(150),
                            )),
                    (machine.start.day != machine.end.day)
                        ? Text(
                            '${machine.end.hour.toString().padLeft(2, '0')}:${machine.end.minute.toString().padLeft(2, '0')} (${machine.end.day.toString().padLeft(2, '0')}/${machine.end.month.toString().padLeft(2, '0')}) to ${machine.end.hour.toString().padLeft(2, '0')}:${machine.end.minute.toString().padLeft(2, '0')}(${machine.start.day.toString().padLeft(2, '0')}/${machine.start.month.toString().padLeft(2, '0')})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black.withAlpha(150),
                            ))
                        : Container(),
                    Text('Purpose: ${machine.purpose}',
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
                            cancelMachine(machine);
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

  Widget mapYourMachines() {
    if (userBookedMachines.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Image.asset('assets/images/addnew.png'),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "Book a machine by going to the Tinkerers' Lab page!",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
            children: userBookedMachines.map((YourBookedMachine machine) {
          return yourBookedMachineCard(machine);
        }).toList()),
      );
    }
  }

  Widget mapYourRooms() {
    if (userRooms.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Image.asset('assets/images/addnew.png'),
            SizedBox(
              height: 40,
            ),
            Text(
              'Book a room by pressing the + button!',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
          ],
        ),
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
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text(bookingTitle),
            children: <Widget>[
              ListTile(
                title: Text('Rooms'),
                onTap: () {
                  setState(() {
                    this.bookingTitle = 'Rooms';
                  });
                },
              ),
              ListTile(
                title: Text('Machines'),
                onTap: () {
                  setState(() {
                    this.bookingTitle = 'Machines';
                  });
                },
              ),
            ],
          ),
          (bookingTitle == 'Rooms') ? mapYourRooms() : mapYourMachines(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "fab1rs", 
            onPressed: (){},
            backgroundColor: Colors.white,
            child: PopupMenuButton<Map<String, List<Tinkerer>>>(
              icon: Icon(Icons.menu, color: Colors.black),
              itemBuilder: (context)=>[
                PopupMenuItem(
                  value: {'Machines' : machinesTL},
                  child: Text('Machine Contacts'),
                ),
                PopupMenuItem(
                  value: {'Lab' : labAccess},
                  child: Text('Lab Access for Workshop'),
                ),
                PopupMenuItem(
                  value: {'Inventory' : inventory},
                  child: Text('Inventory Access'),
                ),
                PopupMenuItem(
                  value: {'Course' : courseAccess},
                  child: Text('Course Access Request'),
                ),
              ],
              onSelected: (value){Navigator.pushNamed(context, '/tlcontacts',arguments: {'dataList':value});},
            ),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "fab2rs",
            backgroundColor: primaryColor,
            onPressed: () {
              Navigator.pushNamed(context, '/selecttime')
                  .then((value) => setState(() {
                        rooms = [];
                        getRooms();
                      }));
            },
            tooltip: 'Book a room',
            child: Icon(Icons.add, color: Colors.white),
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
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(text: 'Your Rooms'),
                Tab(text: 'Occupied Rooms'),
                Tab(
                  text: "Tinkerers' Lab",
                )
              ],
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text('Facility Booking',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.white,
          body: (loading == true || loadingMachines == true)
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: yourRooms(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: occupiedRooms(),
                  ),
                  SingleChildScrollView(child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: tinkerersLab(),
                  )),
                ],
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: (guest)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Image.asset('assets/images/signin.png'),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Please sign in to view this page',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            : homeScreen());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}*/
