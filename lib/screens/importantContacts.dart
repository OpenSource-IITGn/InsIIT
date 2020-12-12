import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';

class ImportantContacts extends StatefulWidget {
  @override
  _ImportantContactsState createState() => _ImportantContactsState();
}

class _ImportantContactsState extends State<ImportantContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Important Contacts',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            children:
                contactCards.map((card) => card.contactCard(context)).toList(),
          ),
        ),
      ),
    );
  }
}
