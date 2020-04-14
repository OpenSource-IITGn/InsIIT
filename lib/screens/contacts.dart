import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';


class Contacts extends StatefulWidget {

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Important Contacts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: contactCards.map((card) => card.contactCard()).toList(),
        ),
      ),
    );
  }
}
