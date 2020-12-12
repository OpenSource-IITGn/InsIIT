import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';

class MessFeedBack extends StatefulWidget {
  @override
  _MessFeedBackState createState() => _MessFeedBackState();
}

class _MessFeedBackState extends State<MessFeedBack> {
  String review = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Mess Feedback',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hey there!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                      "Unhappy with the food? Found anything unusual? Send your review/feedback here.",
                      style: TextStyle(
                          color: Colors.black.withAlpha(150),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextField(
                    minLines: 5,
                    maxLines: 10,
                    onChanged: (v) {
                      review = v;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your review here.'),
                  ),
                  RaisedButton.icon(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: () {
                      sheet.writeData([
                        [
                          DateTime.now().toString(),
                          currentUser['given_name'],
                          currentUser['email'],
                          review
                        ]
                      ], 'messFeedbackText!A:D');
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.send, color: Colors.white),
                    label: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
