import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:instiapp/messMenu/base.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';

class MainHomePage extends StatefulWidget {
  var reload;
  MainHomePage(Function f) {
    this.reload = f;
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
    } else if (hour > 15 && hour <= 19) {
      return {'meal': 'Snacks', 'list': foodList[day].snacks};
    } else {
      return {'meal': 'Dinner', 'list': foodList[day].dinner};
    }
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (context, connectivity, child) {
        bool connected = connectivity != ConnectivityResult.none;
        if (connected != prevConnected) {
          widget.reload();
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
                                imageUrl: currentUser['picture'],
                              )),
                            ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (currentUser == null)
                                  ? "Hey John Doe!"
                                  : "Hey " +
                                      currentUser['given_name'].split(' ')[0] +
                                      '!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "How are you doing today? ",
                              style:
                                  TextStyle(color: Colors.black.withAlpha(150)),
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
                                  "Here's what's for ${selectMeal(foodCards)['meal'].toLowerCase()}",
                                  style: TextStyle(
                                      color: Colors.black.withAlpha(150)),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                        SizedBox(height: 10),
                        // CarouselSlider(
                        //   height: 100.0,
                        //   viewportFraction: 0.3,
                        //   enlargeCenterPage: false,
                        //   autoPlay: true,
                        //   items: selectMeal(foodCards)['list']
                        //       .map<Widget>((i) {
                        //     return Builder(
                        //       builder: (BuildContext context) {
                        //         return Container(
                        //           width: 250.0,
                        //           height: 120.0,
                        //           child: Card(
                        //             // color: primaryColor,
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(15.0),
                        //               child: Center(
                        //                 child: Text(
                        //                   i,
                        //                   style: TextStyle(
                        //                       // fontSize: 20.0,
                        //                       ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   }).toList(),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  ),
                ),
                MessMenuBaseDrawer(selectMeal(foodCards), foodIllustration),
                /*(beta)(twoEvents.length == 0)
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                return Navigator.pushNamed(
                                    context, '/schedule');
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
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withAlpha(150)),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          twoEvents.map((EventModel event) {
                                        return scheduleCard(event);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),*/
                /*(beta)GestureDetector(
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
                                        "Bored?",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Checkout ongoing events",
                                        style: TextStyle(
                                            color: Colors.black.withAlpha(150)
                                            // fontSize: 18.0,
                                            // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                              SizedBox(height: 10),
                              CarouselSlider(
                                height: 300.0,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                items: selectMeal(foodCards)['list']
                                    .map<Widget>((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // color: Colors.black,
                                        child: Container(
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  // color: Colors.black,
                                                  height: 200.0,
                                                  width: ScreenSize.size.width,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      topRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      height: 200.0,
                                                      // width: 300,
                                                      image: NetworkImage(
                                                          'https://assets.entrepreneur.com/content/3x2/2000/20191009140007-GettyImages-1053962188.jpeg'),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: new BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: new BorderRadius
                                                              .only(
                                                          bottomLeft:
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                          bottomRight:
                                                              const Radius
                                                                      .circular(
                                                                  10.0))),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 8, 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceAround,
                                                      children: <Widget>[
                                                        SizedBox(width: 10),
                                                        Column(
                                                          children: <Widget>[
                                                            Text("24",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                )),
                                                            Text('July')
                                                          ],
                                                        ),
                                                        verticalDivider(),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                                "Photography Contest",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                )),
                                                            Text("Starts 7pm!",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withAlpha(
                                                                          150),
                                                                  // fontWeight:
                                                                  //     FontWeight.bold,
                                                                  // fontSize: 16,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),*/

                // RaisedButton(
                //   child: Text("Feed"),
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/feed');
                //   },
                // ),
              ],
            ),
          ),
        );
      },
      child: Container(),
    );
  }
}
