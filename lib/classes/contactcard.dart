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
                      color: Colors.black.withAlpha(200),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  contactJson['designation'],
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            (contactJson['phno'].length > 0)
                ? IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: Colors.black.withAlpha(120),
                    ),
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
                      color: Colors.black.withAlpha(120),
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
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            (description.trim() == '-')
                ? Container()
                : Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withAlpha(150),
                      fontWeight: FontWeight.bold,
                    ),
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
              // SizedBox(
              //   height: 5.0,
              // ),
              // (emails[0] == '-')
              //     ? Container()
              //     : Text(
              //         'Emails',
              //         style: TextStyle(
              //           color: Colors.grey[800],
              //           // fontSize: 18.0,
              //           fontSize: 15.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              // SizedBox(
              //   height: 5.0,
              // ),
              // (emails[0] == '-')
              //     ? Container()
              //     : Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: emails
              //             .map((contact) => contactLink(contact))
              //             .toList(),
              //       ),
              // (websites[0] == '-')
              //     ? Container()
              //     : SizedBox(
              //         height: 5.0,
              //       ),
              // (websites[0] == '-')
              //     ? Container()
              //     : Text(
              //         'Websites',
              //         style: TextStyle(
              //           color: Colors.grey[800],
              //           // fontSize: 18.0,
              //           fontSize: 15.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              // (websites[0] == '-')
              //     ? Container()
              //     : SizedBox(
              //         height: 5.0,
              //       ),
              // (websites[0] == '-')
              //     ? Container()
              //     : Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: websites
              //             .map((contact) => contactLink(contact))
              //             .toList(),
              //       ),
            ],
          ),
        ),
      ],
    );
  }
}
