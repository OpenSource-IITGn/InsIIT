import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard {
  String name;
  List<String> contacts;

  ContactCard({this.name, this.contacts});

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }

  Widget contactLink(contact) {
    return AutolinkText(
      text: contact,
      textStyle: TextStyle(color: Colors.black),
      linkStyle: TextStyle(color: Colors.blue),
      onPhoneTap: (link) => customLaunch('tel:$link'),
      onWebLinkTap: (link) => customLaunch('http:$link'),
      humanize: true,
    );
  }

  Widget contactCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contacts.map((contact) => contactLink(contact)).toList(),
            ),
          ],
        ),
      ),
    );
  }

}