import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';

class CovidPage extends StatefulWidget {
  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.floatingColor,
        child: Icon(
          Icons.assignment_late,
          color: theme.backgroundColor
        ),
        onPressed: () {
          return Navigator.pushNamed(context, "/faqPage");
        },
      ),
    );
  }
}
