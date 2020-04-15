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
