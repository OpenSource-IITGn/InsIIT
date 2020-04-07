import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instiapp',
      theme: ThemeData(
      
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}
