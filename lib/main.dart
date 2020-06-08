import 'package:flutter/material.dart';
import 'package:instiapp/screens/TLForms/firstPage.dart';
import 'package:instiapp/screens/TLForms/fourthPage.dart';
import 'package:instiapp/screens/TLForms/secondPage.dart';
import 'package:instiapp/screens/TLForms/thirdPage.dart';
import 'package:instiapp/screens/developers.dart';
import 'package:instiapp/screens/email.dart';
import 'package:instiapp/screens/eventscalendar.dart';
import 'package:instiapp/screens/eventpage.dart';
import 'package:instiapp/screens/feed/feedPage.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/importantContacts.dart';
import 'package:instiapp/screens/schedule/addCourse.dart';
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
import 'package:instiapp/screens/onboarding.dart';
import 'package:instiapp/screens/misc.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/TLForms/TLContactPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        // '/announcements': (context) => Announcements(),
        // '/articles': (context) => Articles(),
        '/onboarding': (context) => OnboardingPage(),
        '/eventscalendar': (context) => EventsCalendar(),
        '/eventpage': (context) => EventPage(),
        '/schedule': (context) => SchedulePage(),
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
        '/selecttime': (context) => SelectTime(),
        '/RoomBooking': (context) => RoomService(),
        '/misc': (context) => MiscPage(),
        '/availablerooms': (context) => AvailableRooms(),
        '/eventdetail': (context) => EventDetail(),
        '/developers': (context) => DevelopersPage(),
        '/editevent': (context) => EditEvent(),
        '/map': (context) => MapPage(),
        '/firstPage': (context) => FirstPage(),
        '/secondPage': (context) => SecondPage(),
        '/thirdPage': (context) => ThirdPage(),
        '/fourthPage': (context) => FourthPage(),
        '/tlcontacts': (context) => TinkererContact(),
        '/addcourse': (context) => AddCourse(),
      },
      title: 'Instiapp',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'OpenSans'),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(0, 0, 0, 1),
  100:  Color.fromRGBO(0, 0, 0, 1),
  200: Color.fromRGBO(0, 0, 0, 1),
  300: Color.fromRGBO(0, 0, 0, 1),
  400: Color.fromRGBO(0, 0, 0, 1),
  500: Color.fromRGBO(0, 0, 0, 1),
  600:  Color.fromRGBO(0, 0, 0, 1),
  700: Color.fromRGBO(0, 0, 0, 1),
  800: Color.fromRGBO(0, 0, 0, 1),
  900:  Color.fromRGBO(0, 0, 0, 1),
};

MaterialColor colorCustom = MaterialColor(0xFFFF5C57, color);

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize.size = MediaQuery.of(context).size;
    return HomePage(() {});
  }
}
