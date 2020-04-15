import 'package:flutter/material.dart';
import './home.dart';
import './Contacts.dart';
import './Location.dart';
import './Constants.dart';
import './buses.dart';
import './contact.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/Contacts1': (context) => Contact(),
    '/home': (context) => Home(),
    '/Locations': (context) => Location(),

  },
),
);



