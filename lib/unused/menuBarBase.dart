// import 'package:flutter/material.dart';
// import 'package:instiapp/utilities/constants.dart';


// class MenuBarBase extends StatefulWidget {
//   MenuBarBase();

//   @override
//   _MenuBarBaseState createState() => _MenuBarBaseState();
// }

// class _MenuBarBaseState extends State<MenuBarBase>
//     with TickerProviderStateMixin {
//   Animation<double> animation;
//   AnimationController controller;
//   double distanceFromLeft = 0;

//   @override
//   void initState() {
//     super.initState();
//     setupAnimation(0, ScreenSize.size.width - 100);

//     // controller.forward();
//   }

//   void setupAnimation(double start, double end) {
//     controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     animation = Tween<double>(
//       begin: start,
//       end: end,
//     ).animate(controller)
//       ..addListener(() {
//         distanceFromLeft = animation.value;
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           // controller.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           // controller.forward();
//         }
//       });
//   }

//   var startpos, endpos;
//   bool closingBar = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: Container(
//           height: ScreenSize.size.height,
//           width: ScreenSize.size.width,
//           child: GestureDetector(
//             onHorizontalDragStart: (details) {
//               startpos = details.globalPosition;
//               if (startpos.dx >= ScreenSize.size.width * 0.1) {
//                 if (distanceFromLeft > ScreenSize.size.width / 2 &&
//                     startpos.dx > ScreenSize.size.width / 2) {
//                   closingBar = true;
//                 } else {
//                   startpos = Offset(-1, -1);
//                 }
//               } else if (distanceFromLeft > ScreenSize.size.width / 2) {
//                 startpos = Offset(-1, -1);
//               }
//             },
//             onHorizontalDragUpdate: (details) {
//               if (startpos.dx != -1 || closingBar) {
//                 endpos = details.globalPosition;
//                 distanceFromLeft = endpos.dx;
//                 setState(() {});
//               }
//             },
//             onHorizontalDragEnd: (DragEndDetails details) {
//               if (startpos.dx != -1 && closingBar == false) {
//                 if (endpos.dx < ScreenSize.size.width / 4) {
//                   controller.reset();
//                   setupAnimation(endpos.dx, 0);
//                   controller.forward();
//                 } else {
//                   controller.reset();
//                   setupAnimation(endpos.dx, ScreenSize.size.width - 100);
//                   controller.forward();
//                 }
//               } else if (closingBar == true) {
//                 if (endpos.dx < 3*ScreenSize.size.width / 4) {
//                   controller.reset();
//                   setupAnimation(endpos.dx, 0);
//                   controller.forward();
//                 } else {
//                   controller.reset();
//                   setupAnimation(endpos.dx, ScreenSize.size.width - 100);
//                   controller.forward();
//                 }
//               }
//               closingBar = false;
//             },
//             child: Stack(
//               children: <Widget>[
//                 (distanceFromLeft != 0)
//                     ? Container(
//                         color: primaryColor,
//                         height: ScreenSize.size.height,
//                         width: ScreenSize.size.width * 0.8,
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
//                           child: ListView(
//                             children: <Widget>[
//                               UserAccountsDrawerHeader(
//                                 decoration:
//                                     BoxDecoration(color: Colors.transparent),
//                                 currentAccountPicture: CircleAvatar(
//                                   backgroundColor: Colors.orange,
//                                   minRadius: 30,
//                                   child: ClipOval(
//                                       child: Image.network(
//                                     (gSignIn.currentUser == null)?"":gSignIn.currentUser.photoUrl,
//                                     fit: BoxFit.cover,
//                                     width: 90.0,
//                                     height: 90.0,
//                                   )),
//                                 ),
//                                 accountEmail: Text(
//                                   (gSignIn.currentUser == null)?"john.doe@iitgn.ac.in":gSignIn.currentUser.email,
//                                 ),
//                                 accountName: Text(
//                                     (gSignIn.currentUser == null)?"John Doe":gSignIn.currentUser.displayName,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 17)),
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Important Contacts',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.contacts,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(
//                                       context, '/importantcontacts');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Announcements',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.announcement,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(
//                                       context, '/announcements');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Articles',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.art_track,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/articles');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Events Calendar',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.event,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/eventscalendar');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Academic Calendar',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.calendar_today,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/academiccalendar');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Complaints',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.assignment_late,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/complaints');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Shuttle',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.airport_shuttle,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/shuttle');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Mess Menu',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.local_dining,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/messmenu');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Campus Map',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.map,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/map');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Room Booking',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.room,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/RoomBooking');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   'Quicklinks',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.link,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () {
//                                   Navigator.pushNamed(context, '/Quicklinks');
//                                 },
//                               ),
//                               ListTile(
//                                 title: Text(
//                                   "Logout",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 leading: Icon(
//                                   Icons.people,
//                                   color: Colors.white,
//                                 ),
//                                 onTap: () async {
//                                   await gSignIn.signOut();
//                                   Navigator.pushNamed(context, '/signin');
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     : Container(),
//                 Positioned(
//                   left: distanceFromLeft,
//                   top: (ScreenSize.size.height * 0.125) *
//                       distanceFromLeft /
//                       (ScreenSize.size.width),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: secondaryColor.withAlpha(200),
//                           blurRadius:
//                               20.0, // has the effect of softening the shadow
//                           spreadRadius:
//                               1.0, // has the effect of extending the shadow
//                           offset: Offset(
//                             -2.0, // horizontal, move right 10
//                             8.0, // vertical, move down 10
//                           ),
//                         )
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: (distanceFromLeft == 0)
//                           ? BorderRadius.all(Radius.circular(0))
//                           : BorderRadius.all(Radius.circular(25)),
//                       child: GestureDetector(
//                         onTapDown: (s) {
//                           if (distanceFromLeft != 0) {
//                             // controller.reverse();
//                             distanceFromLeft = 0;
//                           }
//                         },
//                         child: Container(
//                             height: ScreenSize.size.height * 0.75 +
//                                 (ScreenSize.size.width - distanceFromLeft) *
//                                     ScreenSize.size.height *
//                                     0.25 /
//                                     ScreenSize.size.width,
//                             width: ScreenSize.size.width,
//                             child: AbsorbPointer(
//                               absorbing:
//                                   (distanceFromLeft > ScreenSize.size.width / 2)
//                                       ? true
//                                       : false,
//                               child: HomePage(() {
//                                 setupAnimation(0, ScreenSize.size.width - 100);
//                                 controller.forward();
//                               }),
//                             )),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )),
//     );
//   }
// }
