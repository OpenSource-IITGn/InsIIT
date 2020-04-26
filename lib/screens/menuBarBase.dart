import 'package:flutter/material.dart';
import 'package:instiapp/auth.dart';
import 'package:instiapp/utilities/constants.dart';

import 'homePage.dart';

class MenuBarBase extends StatefulWidget {
  MenuBarBase();

  @override
  _MenuBarBaseState createState() => _MenuBarBaseState();
}

class _MenuBarBaseState extends State<MenuBarBase>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(
      begin: 0,
      end: ScreenSize.size.width - 100,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // controller.forward();
        }
      });

    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
          height: ScreenSize.size.height,
          width: ScreenSize.size.width,
          child: Stack(
            children: <Widget>[
              Container(
                color: primaryColor,
                height: ScreenSize.size.height,
                width: ScreenSize.size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.transparent),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.orange,
                          minRadius: 30,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text("J",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        accountEmail: Text(
                          "john.doe@iitgn.ac.in",
                        ),
                        accountName: Text("John Doe",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      ListTile(
                        title: Text(
                          'Important Contacts',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.contacts,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/importantcontacts');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Announcements',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.announcement,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/announcements');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Articles',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.art_track,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/articles');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Complaints',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.assignment_late,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/complaints');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Shuttle',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.airport_shuttle,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/shuttle');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Mess Menu',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.local_dining,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/messmenu');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Quicklinks',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.link,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/Quicklinks');
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                        onTap: () {
                          logoutUser() ;
                          Navigator.pushNamed(context, '/signin');

                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: animation.value,
                top: (ScreenSize.size.height * 0.125) *
                    animation.value /
                    (ScreenSize.size.width),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: secondaryColor.withAlpha(200),
                        blurRadius:
                            20.0, // has the effect of softening the shadow
                        spreadRadius:
                            1.0, // has the effect of extending the shadow
                        offset: Offset(
                          -2.0, // horizontal, move right 10
                          8.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: (animation.value == 0)
                        ? BorderRadius.all(Radius.circular(0))
                        : BorderRadius.all(Radius.circular(25)),
                    child: GestureDetector(
                      onTapDown: (s) {
                        if (animation.value != 0) {
                          controller.reverse();
                        }
                      },
                      child: Container(
                          height: ScreenSize.size.height * 0.75 +
                              (ScreenSize.size.width - animation.value) *
                                  ScreenSize.size.height *
                                  0.25 /
                                  ScreenSize.size.width,
                          width: ScreenSize.size.width,
                          child: HomePage(() {
                            controller.forward();
                          })),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
