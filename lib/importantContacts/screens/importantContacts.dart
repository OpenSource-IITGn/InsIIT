import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/importantContacts/classes/contactcard.dart';
import 'package:instiapp/themeing/notifier.dart';

class ImportantContacts extends StatefulWidget {
  @override
  _ImportantContactsState createState() => _ImportantContactsState();
}

class _ImportantContactsState extends State<ImportantContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: theme.appBarColor,
        title: Text('Important Contacts',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
        iconTheme: IconThemeData(color: theme.iconColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            children: dataContainer.contacts.contactCards
                .map<Widget>((ContactCard card) => card.contactCard(context))
                .toList(),
          ),
        ),
      ),
    );
  }
}
