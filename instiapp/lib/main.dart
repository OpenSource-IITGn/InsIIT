import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/addtext.dart';
import 'package:instiapp/screens/announcements.dart';
import 'package:instiapp/screens/articles.dart';
import 'package:instiapp/screens/complains.dart';
import 'package:instiapp/screens/contacts.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/announcements': (context) => Announcements(),
        '/articles': (context) => Articles(),
        '/contacts': (context) => Contacts(),
        '/complaints': (context) => Complains(),
        '/addtext': (context) => AddText(),
      },
      title: 'Instiapp',
      theme: ThemeData(
      
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}
