import 'package:flutter/material.dart';
import 'package:instiapp/screens/TLForms/firstPage.dart';
import 'package:instiapp/screens/TLForms/fourthPage.dart';
import 'package:instiapp/screens/TLForms/secondPage.dart';
import 'package:instiapp/screens/TLForms/thirdPage.dart';
import 'package:instiapp/screens/email.dart';
import 'package:instiapp/screens/eventscalendar.dart';
import 'package:instiapp/screens/eventpage.dart';
import 'package:instiapp/screens/feed/feedPage.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/importantContacts.dart';
import 'package:instiapp/screens/schedule/eventDetail.dart';
import 'package:instiapp/screens/map/googlemap.dart';
import 'package:instiapp/screens/messMenu/messfeedback.dart';
import 'package:instiapp/screens/messMenu/messmenu.dart';
import 'package:instiapp/screens/roomBooking/AvailableRooms.dart';
import 'package:instiapp/screens/roomBooking/Selecttime.dart';
import 'package:instiapp/screens/roomBooking/form3.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:instiapp/screens/schedule/editEvent.dart';
import 'package:instiapp/screens/schedule/schedulePage.dart';
import 'package:instiapp/screens/shuttle.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:instiapp/utilities/constants.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      debugShowCheckedModeBanner: false,
      routes: {
        // '/announcements': (context) => Announcements(),
        // '/articles': (context) => Articles(),
        '/eventscalendar': (context) => EventsCalendar(),
        '/eventpage': (context) => EventPage(),
        '/schedule':(context) => SchedulePage(),
        '/feed': (context) => FeedPage(),
        // '/academiccalendar': (context) => AcademicCalendar(),
        '/importantcontacts': (context) => ImportantContacts(),
        // '/complaints': (context) => Complains(),
        '/shuttle': (context) => Shuttle(),
        // '/addtext': (context) => AddText(),
        '/Quicklinks': (context) => Email(),
        '/messmenu': (context) => MessMenu(),
        '/messfeedback': (context) => MessFeedBack(),
        '/signin': (context) => SignInPage(),
        '/menuBarBase': (context) => HomeWrapper(),
        '/bookingform': (context) => BookingForm(),
        '/selecttime' : (context) => SelectTime(),
        '/RoomBooking' : (context) => RoomService(),
        '/availablerooms' : (context) => AvailableRooms(),
        '/eventdetail' : (context) => EventDetail(),
        '/editevent' : (context) => EditEvent(),
        '/map' : (context) => MapPage(),
        '/firstPage': (context) => FirstPage(),
        '/secondPage': (context) => SecondPage(),
        '/thirdPage': (context) => ThirdPage(),
        '/fourthPage': (context) => FourthPage(),
      },
      title: 'Instiapp',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'OpenSans'),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize.size = MediaQuery.of(context).size;
    return HomePage((){});
  }
}

