import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:instiapp/data/scheduleContainer.dart';
import 'package:instiapp/messMenu/classes/base.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:http/http.dart' as http;

class MainHomePage extends StatefulWidget {
  var reload;
  MainHomePage(Function reloadEverythingCallback) {
    this.reload = reloadEverythingCallback;
  }

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with AutomaticKeepAliveClientMixin<MainHomePage> {
  bool prevConnected = true;
  String qod;
  String qodAuthor;

  @override
  void initState() {
    super.initState();
    http.get('https://quotes.rest/qod').then((response) {
      if (response.statusCode == 200) {
        var temp = jsonDecode(response.body)['contents']['quotes'][0];
        qod = '\"' + temp['quote'] + '\"';
        qodAuthor = '- ' + temp['author'];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (context, connectivity, child) {
        bool connected = connectivity != ConnectivityResult.none;
        if (connected != prevConnected) {
          widget.reload();
          dataContainer.schedule.buildData();
          print("reloading");
          prevConnected = connected;
        }
        dataContainer.schedule.buildData();
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
                      (dataContainer.auth.user == null)
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
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                height: 90.0,
                                imageUrl: dataContainer.auth.user.photoUrl,
                              )),
                            ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (dataContainer.auth.user == null)
                                  ? "Hey John Doe!"
                                  : "Hey " +
                                      dataContainer.auth.user.displayName
                                          .split(' ')[0] +
                                      '!',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textHeadingColor),
                            ),
                            Text("How are you doing today? ",
                                style: TextStyle(
                                    color: theme.textSubheadingColor)),
                          ]),
                    ]),
                SizedBox(height: 10),
                Text(
                  qod ?? '',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      color: theme.textSubheadingColor),
                ),
                Text(
                  qodAuthor ?? '',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      color: theme.textSubheadingColor),
                ),
                SizedBox(height: 10),
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
                                    color: theme.textHeadingColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Here's what's for ${(dataContainer.mess.foodCards == null || dataContainer.mess.foodCards.length != 7) ? 'food' : dataContainer.mess.foodItems['meal'].toLowerCase()}",
                                  style: TextStyle(
                                      color: theme.textSubheadingColor),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward, color: theme.iconColor),
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
                    : MessMenuBaseDrawer(widget.reload),
                GestureDetector(
                  onTap: () {
                    return Navigator.pushNamed(context, '/schedule');
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
                                  "Wondering what's next?",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textHeadingColor),
                                ),
                                Text(
                                  (dataContainer.schedule.twoEvents == null ||
                                          dataContainer
                                                  .schedule.twoEvents.length ==
                                              0)
                                      ? "Enjoy your free time!"
                                      : "Here's your schedule",
                                  style: TextStyle(
                                      color: theme.textSubheadingColor),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward,
                                color:
                                    (dataContainer.schedule.twoEvents == null ||
                                            dataContainer.schedule.twoEvents
                                                    .length ==
                                                0)
                                        ? theme.iconColor.withAlpha(150)
                                        : theme.iconColor),
                          ],
                        ),
                        SizedBox(height: 10),
                        // RaisedButton(
                        //     child: Text("RELOAD"),
                        //     onPressed: () {
                        //       dataContainer.schedule.getAllCourses();
                        //     }),
                        (dataContainer.schedule.twoEvents == null ||
                                dataContainer.schedule.twoEvents.length == 0)
                            ? Container()
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: dataContainer.schedule.twoEvents
                                    .map<Widget>(
                                        (event) => event.buildEventCard(context))
                                    .toList(),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
