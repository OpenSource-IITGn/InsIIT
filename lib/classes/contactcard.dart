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

  ContactCard(
      {this.name, this.description, this.contacts, this.emails, this.websites});

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
      textStyle: TextStyle(
        color: Colors.grey[800],
        // fontSize: 16.0,
      ),
      linkStyle: TextStyle(
        color: Colors.blue[600],
        // fontSize: 16.0,
      ),
      onPhoneTap: (link) => customLaunch('tel:$link'),
      onWebLinkTap: (link) => customLaunch('http:$link'),
      humanize: true,
    );
  }

  Widget contactCard() {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            (description.trim() == '-')
                ? Container()
                : Text(
                    description,
                    style: TextStyle(
                        // fontSize: 18.0,
                        ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Contact',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  contacts.map((contact) => contactLink(contact)).toList(),
            ),
            SizedBox(
              height: 5.0,
            ),
            (emails[0] == '-')
                ? Container()
                : Text(
                    'Emails',
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 18.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            (emails[0] == '-')
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        emails.map((contact) => contactLink(contact)).toList(),
                  ),
            (websites[0] == '-')
                ? Container()
                : SizedBox(
                    height: 5.0,
                  ),
            (websites[0] == '-')
                ? Container()
                : Text(
                    'Websites',
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 18.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            (websites[0] == '-')
                ? Container()
                : SizedBox(
                    height: 5.0,
                  ),
            (websites[0] == '-')
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: websites
                        .map((contact) => contactLink(contact))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
