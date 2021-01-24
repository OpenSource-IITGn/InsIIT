import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';

class MessFeedBack extends StatefulWidget {
  @override
  _MessFeedBackState createState() => _MessFeedBackState();
}

class _MessFeedBackState extends State<MessFeedBack> {
  String review = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text('Mess Feedback',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
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
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: theme.textHeadingColor)),
                  SizedBox(height: 8),
                  Text(
                      "Loved something? Unhappy with the food? Send your feedback here.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.textSubheadingColor)),
                  SizedBox(height: 10),
                  TextField(
                    minLines: 5,
                    maxLines: 10,
                    onChanged: (v) {
                      review = v;
                    },
                    style: TextStyle(color: theme.textHeadingColor),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: theme.textHeadingColor.withAlpha(100)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: 'Enter your review here.'),
                  ),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: theme.buttonColor,
                    onPressed: () {
                      dataContainer.mess.sheet.writeData([
                        [
                          DateTime.now().toString(),
                          dataContainer.auth.user.displayName,
                          dataContainer.auth.user.email,
                          review
                        ]
                      ], 'messFeedbackText!A:D');
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.send, color: theme.buttonContentColor),
                    label: Text(
                      'Submit',
                      style: TextStyle(color: theme.buttonContentColor),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
