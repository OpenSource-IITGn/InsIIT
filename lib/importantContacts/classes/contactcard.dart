import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';
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

  Widget contactLink(context, contactJson) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  contactJson['name'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: theme.textHeadingColor),
                ),
                Text(
                  contactJson['designation'],
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.textHeadingColor),
                ),
              ],
            ),
            (contactJson['phno'].length > 0)
                ? IconButton(
                    icon: Icon(Icons.phone, color: theme.iconColor),
                    onPressed: () {
                      List phones = contactJson['phno'];
                      if (phones.length > 1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(contactJson['name']),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: phones.map((phone) {
                                    return ListTile(
                                        title: Text("$phone"),
                                        trailing: Icon(
                                          Icons.phone,
                                        ),
                                        onTap: () {
                                          launch('tel:$phone');
                                        });
                                  }).toList()),
                            );
                          },
                        );
                      } else {
                        launch('tel:${phones[0]}');
                      }
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.language,
                      color: theme.iconColor,
                    ),
                    onPressed: () {
                      launch(contactJson['website']);
                    },
                  )
          ],
        ),
        Divider(),
      ],
    );
    // return AutolinkText(
    //   text: contact,
    //   textStyle: TextStyle(
    //     color: Colors.grey[800],
    //     // fontSize: 16.0,
    //   ),
    //   linkStyle: TextStyle(
    //     color: Colors.blue[600],
    //     // fontSize: 16.0,
    //   ),
    //   onPhoneTap: (link) => customLaunch('tel:$link'),
    //   onWebLinkTap: (link) => customLaunch('http:$link'),
    //   humanize: true,
    // );
  }

  Widget contactCard(context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textHeadingColor),
            ),
            (description.trim() == '-')
                ? Container()
                : Text(
                    description,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.textSubheadingColor),
                  ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 15, 25, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: contacts
                    .map((contact) => contactLink(context, contact))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
