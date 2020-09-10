/*(beta)import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/Selecttime.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/utilities/constants.dart';

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

  makeItemModel() {
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

  Widget blockHead(name) {
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

  Widget roomsDetail(List<Room> rooms, roomdetail) {
    if (rooms.length != 0) {
      return Column(
        children: rooms.map((Room room) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
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
                OutlineButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bookingform',
                        arguments: {
                          '_room': room.roomno,
                          '_block': room.block,
                          '_id': room.roomId,
                        });
                  },
                  icon: Icon(Icons.add_box, color: Colors.black,),
                  label: Text('Book'),
                ),
              ],
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
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: allBlocks.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: blockHead(blocks[index].header),
            children: <Widget>[
              roomsDetail(blocks[index].bodyModel, blocks[index].header)
            ],
          );
        },
      ),
    );
  }
}*/
