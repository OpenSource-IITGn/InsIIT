import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard {
  String name;
  String description;
  List contacts;
  List emails;
  List websites;

  ContactCard({this.name, this.description, this.contacts, this.emails, this.websites});

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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              description,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              'Contact:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contacts.map((contact) => contactLink(contact)).toList(),
            ),
            SizedBox(height: 5.0,),
            Text(
              'Emails:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: emails.map((contact) => contactLink(contact)).toList(),
            ),
            SizedBox(height: 5.0,),
            Text(
              'Websites:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: websites.map((contact) => contactLink(contact)).toList(),
            ),
          ],
        ),
      ),
    );
  }

}