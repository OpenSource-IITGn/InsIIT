import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  Map machineData = {};
  List<ItemModelSimple> machineModels = [];

  Widget machineHead (name) {
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

  Widget timeBody (List<RoomTime> times) {
    if (times.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Machine"
            " is free!"),
      );
    }
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

  @override
  Widget build(BuildContext context) {

    machineData = ModalRoute.of(context).settings.arguments;
    String type = machineData['type'];
    List<Machine> machines = machineData['machines'];
    machines.forEach((Machine machine) {
      List<RoomTime> bookedSlots = [];
      machine.bookedslots.forEach((RoomTime time) {
        if (time.end.isAfter(DateTime.now()) && time.start.isBefore(DateTime.now()) ){
          bookedSlots.add(time);
        }
      });
      machineModels.add(ItemModelSimple(header: machine.model, bodyModel: bookedSlots));
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            selectedIndex = 4;
            Navigator.pushReplacementNamed(context, '/menuBarBase');
          },
        ),
        title: Text(type,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: machines.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              title: machineHead(machineModels[index].header),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: timeBody(
                      machineModels[index].bodyModel),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/secondPage', arguments: {
            'type': type,
            'machines': machines,
          });
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
