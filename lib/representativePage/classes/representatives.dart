import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Representative {
  String position;
  String description;
  List profiles;
  List<String> batch;
  String currentBatch;
  List currentProfiles;

  Representative(
      {this.position,
      this.description,
      this.profiles,
      this.batch,
      this.currentBatch});

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }

  makeListOfCurrentProfiles() {
    currentProfiles = [];

    if (currentBatch == null || currentBatch == "") {
      currentProfiles = profiles;
    } else {
      profiles.forEach((jsonData) {
        if (jsonData["batch"] == currentBatch) {
          currentProfiles.add(jsonData);
        }
      });
    }
  }

  Widget profileLink(context, contactJson) {
    return Card(
      color: theme.cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  minRadius: 18,
                  child: ClipOval(
                      child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 75.0,
                    placeholder: (context, url) => CircularProgressIndicator(
                      backgroundColor: theme.iconColor,
                    ),
                    height: 75.0,
                    imageUrl: contactJson['image'],
                  )),
                ),
              ],
            ),
            Text(
              contactJson['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.textHeadingColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              contactJson['designation'],
              style: TextStyle(
                color: theme.textSubheadingColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (contactJson['phno'].length > 0)
                      ? IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: theme.iconColor,
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
                                                color: theme.iconColor,
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
                      : Container(),
                  (contactJson['email'].length > 0)
                      ? IconButton(
                          icon: Icon(
                            Icons.email,
                            color: theme.iconColor,
                          ),
                          onPressed: () {
                            List emails = contactJson['email'];
                            if (emails.length > 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(contactJson['name']),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: emails.map((email) {
                                          return ListTile(
                                              title: Text("$email"),
                                              trailing: Icon(
                                                Icons.phone,
                                              ),
                                              onTap: () {
                                                launch(
                                                    'mailto:$email?subject=&body=');
                                              });
                                        }).toList()),
                                  );
                                },
                              );
                            } else {
                              launch('mailto:${emails[0]}?subject=&body=');
                            }
                          },
                        )
                      : Container(),
                ]),
          ],
        ),
      ),
    );
  }

  Widget profileCard(context, Function callback) {
    makeListOfCurrentProfiles();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor),
                ),
                Text(
                  currentBatch,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textSubheadingColor),
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list_alt, color: theme.iconColor),
              itemBuilder: (context) => batch
                  .map((String group) => PopupMenuItem(
                        value: group,
                        child: Text(
                          group,
                          style: TextStyle(color: theme.textHeadingColor),
                        ),
                      ))
                  .toList(),
              onSelected: (value) {
                currentBatch = value;
                callback();
              },
            )
          ],
        ),
      ),
      SizedBox(
        height: 3,
      ),
      CarouselSlider(
          items: currentProfiles
              .map((contact) => profileLink(context, contact))
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.4,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ))
    ]);
  }
}
