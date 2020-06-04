import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/Selecttime.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';

class AvailableRooms extends StatefulWidget {
  @override
  _AvailableRoomsState createState() => _AvailableRoomsState();
}

class _AvailableRoomsState extends State<AvailableRooms> {

  List<ItemModel> blocks = [];

  @override
  void initState() {
    super.initState();
    makeItemModel();
  }

  Map<String, List<Room>> allBlocks = {};

  makeItemModel () {
    availableRooms.forEach((Room room) {
      if (allBlocks.containsKey(room.block)) {
        allBlocks[room.block].add(room);
      } else {
        allBlocks.putIfAbsent(room.block, () => [room]);
      }
    });

    allBlocks.forEach((String block, List<Room> rooms) {
      blocks.add(ItemModel(header: block, bodyModel: rooms));
    });
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
                    '${room.roomno}',
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
                        '_room': room.roomno,
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


