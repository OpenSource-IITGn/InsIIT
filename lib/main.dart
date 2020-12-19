import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
//(beta)import 'package:instiapp/screens/TLForms/firstPage.dart';
//(beta)import 'package:instiapp/screens/TLForms/fourthPage.dart';
//(beta)import 'package:instiapp/screens/TLForms/secondPage.dart';
//(beta)import 'package:instiapp/screens/TLForms/thirdPage.dart';
import 'package:instiapp/screens/developers.dart';
import 'package:instiapp/screens/email.dart';

import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/importantContacts.dart';
import 'package:instiapp/screens/map/googlemap.dart';
import 'package:instiapp/screens/messMenu/messfeedback.dart';
import 'package:instiapp/screens/messMenu/messmenu.dart';

import 'package:instiapp/screens/schedule/addCourse.dart';
import 'package:instiapp/screens/schedule/editEvent.dart';
import 'package:instiapp/screens/schedule/eventDetail.dart';
import 'package:instiapp/screens/schedule/exportIcsFile.dart';
import 'package:instiapp/screens/schedule/schedulePage.dart';

import 'package:instiapp/screens/loading.dart';
import 'package:instiapp/screens/shuttle.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:instiapp/screens/onboarding.dart';
import 'package:instiapp/screens/misc.dart';
import 'package:instiapp/utilities/constants.dart';

import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  int k = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (k == 0) {
            if (kDebugMode) {
              print("Enabled Crashlytics");
              FirebaseCrashlytics.instance
                  .setCrashlyticsCollectionEnabled(false);
            } else {}
            k = 1;
          }
          return MaterialApp(
            initialRoute: '/signin',
            key: navigatorKey,
            debugShowCheckedModeBanner: false,
            routes: {
              // '/announcements': (context) => Announcements(),
              // '/articles': (context) => Articles(),
              '/onboarding': (context) => OnboardingPage(),
              //(beta)'/eventscalendar': (context) => EventsCalendar(),
              //(beta)'/eventpage': (context) => EventPage(),
              '/schedule': (context) => SchedulePage(),
              //(beta)'/feed': (context) => FeedPage(),
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
              //(beta)'/bookingform': (context) => BookingForm(),
              //(beta)'/selecttime': (context) => SelectTime(),
              //(beta)'/RoomBooking': (context) => RoomService(),
              '/misc': (context) => MiscPage(),
              //(beta)'/availablerooms': (context) => AvailableRooms(),
              '/eventdetail': (context) => EventDetail(),
              '/developers': (context) => DevelopersPage(),
              '/editevent': (context) => EditEvent(),
              '/map': (context) => MapPage(),
              //(beta)'/firstPage': (context) => FirstPage(),
              //(beta)'/secondPage': (context) => SecondPage(),
              //(beta)'/thirdPage': (context) => ThirdPage(),
              //(beta)'/fourthPage': (context) => FourthPage(),
              //(beta)'/tlcontacts': (context) => TinkererContact(),
              '/addcourse': (context) => AddCourse(),
              '/exportIcsFile': (context) => ExportIcsFile(),
            },
            title: 'Instiapp',
            theme:
                ThemeData(primarySwatch: Colors.indigo, fontFamily: 'OpenSans'),
          );
        }
        return loadScreen();
      },
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(0, 0, 0, 1),
  100: Color.fromRGBO(0, 0, 0, 1),
  200: Color.fromRGBO(0, 0, 0, 1),
  300: Color.fromRGBO(0, 0, 0, 1),
  400: Color.fromRGBO(0, 0, 0, 1),
  500: Color.fromRGBO(0, 0, 0, 1),
  600: Color.fromRGBO(0, 0, 0, 1),
  700: Color.fromRGBO(0, 0, 0, 1),
  800: Color.fromRGBO(0, 0, 0, 1),
  900: Color.fromRGBO(0, 0, 0, 1),
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
