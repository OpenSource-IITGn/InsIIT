import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:instiapp/messMenu/classes/base.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/mainScreens/loading.dart';

class MainHomePage extends StatefulWidget {
  var reload, readyEvents;
  MainHomePage(Function f, Function e) {
    this.reload = f;
    this.readyEvents = e;
  }

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  bool prevConnected = true;
  Map selectMeal(List foodList) {
    int day = DateTime.now().weekday - 1;
    int hour = DateTime.now().hour;
    if (hour >= 4 && hour <= 10) {
      return {'meal': 'Breakfast', 'list': foodList[day].breakfast};
    } else if (hour > 10 && hour <= 15) {
      return {'meal': 'Lunch', 'list': foodList[day].lunch};
    } else if (hour > 15 && hour < 19) {
      return {'meal': 'Snacks', 'list': foodList[day].snacks};
    } else {
      return {'meal': 'Dinner', 'list': foodList[day].dinner};
    }
  }

  Widget scheduleCard(EventModel event) {
    return Card(
      child: Container(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    time(event.start),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to", style: TextStyle(fontSize: 14)),
                    SizedBox(
                      height: 8,
                    ),
                    time(event.end),
                  ]),
                ),
                verticalDivider(),
                Expanded(
                  flex: 3,
                  child: descriptionWidget(event),
                ),
              ],
            )),
      ),
    );
  }

  Widget descriptionWidget(EventModel event) {
    if (event.isCourse) {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.courseId,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(event.courseName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Text((event.eventType == null) ? 'Course' : event.eventType,
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text('Room: ${event.location}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                ],
              ),
            ]),
      );
    } else if (event.isExam) {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.courseId,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Text(event.courseName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Text(event.eventType,
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('Room: ',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text('Roll Numbers: ',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(event.location,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(event.rollNumbers,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  ),
                ],
              ),
            ]),
      );
    } else {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(stringReturn(event.description),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Text(stringReturn(event.summary),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                height: 8,
              ),
              Text(
                  stringReturn(event.eventType) +
                      ' (' +
                      stringReturn(event.remarks) +
                      ')',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
            ]),
      );
    }
  }

  Widget time(DateTime time) {
    return Text(
        twoDigitTime(time.hour.toString()) +
            ':' +
            twoDigitTime(time.minute.toString()),
        style: TextStyle(fontSize: 14));
  }

  String twoDigitTime(String text) {
    if (text.length == 1) {
      String _text = '0' + text;
      return _text;
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (context, connectivity, child) {
        bool connected = connectivity != ConnectivityResult.none;
        if (connected != prevConnected) {
          widget.reload();
          widget.readyEvents();
          print("reloading");
          prevConnected = connected;
        }
        return new SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 60),
                AnimatedContainer(
                  decoration: new BoxDecoration(
                      color: Color(0xFFEE4400),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(10.0))),
                  height: (connected) ? 0 : 24,
                  width: 100,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.linear,
                  child: Center(
                    child: Text(
                      "Offline",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                (connected)
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      (currentUser == null)
                          ? Image.asset(
                              'assets/images/avatar.png',
                              fit: BoxFit.cover,
                              width: 90.0,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              minRadius: 30,
                              child: ClipOval(
                                  child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 90.0,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                height: 90.0,
                                imageUrl: currentUser.imageUrl,
                              )),
                            ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (currentUser == null)
                                  ? "Hey John Doe!"
                                  : "Hey " +
                                      currentUser.name.split(' ')[0] +
                                      '!',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "How are you doing today? ",
                              style: TextStyle(),
                            ),
                            // Text(
                            //   "3 days to the weekend \uf601",
                            //   style: TextStyle(
                            //     fontSize: 12.0,
                            //     fontStyle: FontStyle.italic,
                            //       color: Colors.black.withAlpha(150)),
                            // ),
                          ]),
                    ]),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    return Navigator.pushNamed(context, '/messmenu');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Hungry?",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Here's what's for ${selectMeal(dataContainer.mess.foodCards)['meal'].toLowerCase()}",
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                (dataContainer.mess.foodCards == null ||
                        dataContainer.mess.foodCards.length != 7)
                    ? Container()
                    : MessMenuBaseDrawer(
                        selectMeal(dataContainer.mess.foodCards),
                        dataContainer.mess.foodIllustration),
                (dataContainer.schedule.twoEvents.length == 0)
                    ? GestureDetector(
                        onTap: () {
                          return Navigator.pushNamed(context, '/schedule');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Wondering what's next?",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Enjoy your free time :)",
                                        style: TextStyle(),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward,
                                      color: Colors.black.withAlpha(75)),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          return Navigator.pushNamed(context, '/schedule');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Wondering what's next?",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Here's your schedule",
                                        style: TextStyle(),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                              SizedBox(height: 10),
                              (dataContainer.schedule.twoEvents == null ||
                                      dataContainer.schedule.twoEvents.length ==
                                          0)
                                  ? Container()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: dataContainer.schedule.twoEvents
                                          .map((EventModel event) {
                                        return scheduleCard(event);
                                      }).toList(),
                                    ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
      child: Container(),
    );
  }
}
