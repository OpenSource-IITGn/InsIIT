/*(beta)import 'package:flutter/material.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/utilities/constants.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Map machineData = {};
  List<ItemModelSimple> machineModels = [];

  Widget machineHead(name) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget timeBody(List<RoomTime> times) {
    if (times.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Machine"
            " is free!"),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: times.map<Widget>((time) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        launch(time.mobNo);
                      },
                      child: Text("Call")),
                  FlatButton(
                      onPressed: () {
                        launch("whatsapp://send?phone=+91${time.mobNo}");
                      },
                      child: Text("WhatsApp")),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"))
                ],
                content: Text(
                    'Booked by: ${time.name} \n Mobile no.: ${time.mobNo}'),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.calendar_today),
                  Text(
                      '${time.start.hour.toString().padLeft(2, '0')}:${time.start.minute.toString().padLeft(2, '0')} (${time.start.day}/${time.start.month}) to ${time.end.hour.toString().padLeft(2, '0')}:${time.end.minute.toString().padLeft(2, '0')} (${time.end.day}/${time.end.month})'),
                  OutlineButton(onPressed: null, child: Text("View"))
                ]),
          ),
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
        if (time.end.isAfter(DateTime.now()) &&
            time.start.isBefore(DateTime.now())) {
          bookedSlots.add(time);
        }
      });
      machineModels
          .add(ItemModelSimple(header: machine.model, bodyModel: bookedSlots));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
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
              children: <Widget>[timeBody(machineModels[index].bodyModel)],
            );
            return ExpansionPanelList(
              expansionCallback: (int item, bool status) {
                setState(() {
                  machineModels[index].isExpanded =
                      !machineModels[index].isExpanded;
                });
              },
              animationDuration: Duration(seconds: 1),
              children: [
                ExpansionPanel(
                  body: Container(
                    padding: EdgeInsets.all(15.0),
                    child: timeBody(machineModels[index].bodyModel),
                  ),
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return machineHead(machineModels[index].header);
                  },
                  isExpanded: machineModels[index].isExpanded,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushReplacementNamed(context, '/thirdPage',
          //               arguments: {
          //                 'type': type,
          //                 'machines': machines,
          //                 'files': null,
          //               });
          Navigator.pushNamed(context, '/secondPage', arguments: {
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
}*/
