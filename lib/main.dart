import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instiapp/covid/screens/covidPage.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/feed/screens/hashtagsPage.dart';
import 'package:instiapp/developers/screens/developers.dart';
import 'package:instiapp/notifications/pushNotifications.dart';
import 'package:instiapp/quickLinks/screens/email.dart';

import 'package:instiapp/mainScreens/homePage.dart';
import 'package:instiapp/importantContacts/screens/importantContacts.dart';
import 'package:instiapp/map/screens/googlemap.dart';
import 'package:instiapp/messMenu/screens/messfeedback.dart';
import 'package:instiapp/messMenu/screens/messmenu.dart';
import 'package:instiapp/schedule/screens/addCourse.dart';

import 'package:instiapp/schedule/screens/editEvents.dart';
import 'package:instiapp/schedule/screens/eventDetail.dart';
import 'package:instiapp/schedule/screens/schedulePage.dart';
import 'package:instiapp/shuttle/screens/shuttle.dart';
import 'package:instiapp/mainScreens/signIn.dart';
import 'package:instiapp/mainScreens/onboarding.dart';
import 'package:instiapp/mainScreens/miscPage.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/representativePage/screens/representativePage.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dataContainer = DataContainer();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await dataContainer.initializeCaches();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/importantcontacts': (context) => ImportantContacts(),
        '/shuttle': (context) => Shuttle(),
        '/Quicklinks': (context) => Email(),
        '/messmenu': (context) => MessMenu(),
        '/messfeedback': (context) => MessFeedBack(),
        '/signin': (context) => SignInPage(),
        '/menuBarBase': (context) => HomeWrapper(),
        '/hashtags': (context) => HashtagPage(),
        '/misc': (context) => MiscPage(),
        '/developers': (context) => DevelopersPage(),
        '/map': (context) => MapPage(),
        '/schedule': (context) => SchedulePage(),
        '/eventdetail': (context) => EventDetail(),
        '/editevent': (context) => EditEvent(),
        '/addCourses': (context) => AddCoursePage(),
        //'/exportIcsFile': (context) => ExportIcsFile(),
        '/representativePage': (context) => RepresentativePage(),
        '/covidPage': (context) => CovidPage(),
      },
      title: 'Instiapp',
      theme: ThemeData(fontFamily: 'OpenSans', accentColor: Colors.black),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize.size = MediaQuery.of(context).size;
    return HomePage(() {});
  }
}
