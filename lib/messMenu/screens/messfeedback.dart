import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
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
          centerTitle: true,
          title: Text('Mess Feedback',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hey there!",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                      "Loved something? Unhappy with the food? Send your feedback here.",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: () {
                      sheet.writeData([
                        [
                          DateTime.now().toString(),
                          dataContainer.auth.user.name,
                          dataContainer.auth.user.email,
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
