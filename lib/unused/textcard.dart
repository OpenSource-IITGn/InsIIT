/*(beta)import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';

class TextCard {

  String title;
  String description;
  File image;
  int upVote = 0;
  String pressed;
  int downVote = 0;
  Color upVoteColor = Colors.black;
  Color downVoteColor = Colors.black;

  TextCard({this.title, this.description, this.image});

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }

  Widget link(text) {
    return AutolinkText(
      text: text,
      textStyle: TextStyle(color: Colors.black),
      linkStyle: TextStyle(color: Colors.blue),
      onPhoneTap: (link) => customLaunch('tel:$link'),
      onWebLinkTap: (link) => customLaunch('$link'),
      humanize: true,
    );
  }

  Widget textCard () {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: 150.0,
              height: 150.0,
              child: Center(
                child: image == null ?
                Text("No Image") :
                PhotoView(
                  backgroundDecoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  imageProvider: FileImage(image),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            link(description),
          ],
        ),
      ),
    );
  }

}*/

