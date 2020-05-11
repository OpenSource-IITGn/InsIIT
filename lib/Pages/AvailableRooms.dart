import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/Pages/functions.dart';
import 'package:instiapp/Pages/Selecttime.dart';
import 'package:instiapp/utilities/constants.dart';

class AvailableRooms extends StatefulWidget {
  @override
  _AvailableRoomsState createState() => _AvailableRoomsState();
}

class _AvailableRoomsState extends State<AvailableRooms> {

  List<ItemModel> blocks;

  List<Room> block1 = [];
  List<Room> block2 = [];
  List<Room> block3 = [];
  List<Room> block4 = [];
  List<Room> block5 = [];
  List<Room> block6 = [];
  List<Room> block7 = [];

  @override
  void initState() {
    super.initState();
    makeItemModel();
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

  makeItemModel () {
    availableRooms.forEach((Room room) {
      addToBlock(room);
    });
    blocks = [
      ItemModel(header: 'Block 1', bodyModel: block1),
      ItemModel(header: 'Block 2', bodyModel: block2),
      ItemModel(header: 'Block 3', bodyModel: block3),
      ItemModel(header: 'Block 4', bodyModel: block4),
      ItemModel(header: 'Block 5', bodyModel: block5),
      ItemModel(header: 'Block 6', bodyModel: block6),
      ItemModel(header: 'Block 7', bodyModel: block7),
    ];
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

  Widget roomsDetail (List<Room> rooms) {
    if (rooms.length != 0) {
      return Column(
        children: rooms.map((Room room) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/bookingform', arguments: {
                        '_room': room.room,
                        '_block': room.block,
                      });
                    },
                    child: Text('Book'),
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Room'),
      ),
      body: Container(
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
                    child: roomsDetail(blocks[index].bodyModel),
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
      ),
    );
  }
}


