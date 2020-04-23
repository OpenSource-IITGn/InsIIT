import 'package:flutter/material.dart';
import 'package:instiapp/classes/contact.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  List<Contacts> contact = [
    Contacts (name:'ABC',textNo:'9929676589' ),
    Contacts (name:'ABC',textNo:'9929676589'),
    Contacts (name:'ABC',textNo:'9929676589'),
    Contacts (name:'XYZ',textNo:'9929676589'),
  ];

  Widget contactTemplate(contacts) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(contacts.name,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 6.0,),
              Text(contacts.textNo,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              RaisedButton.icon(onPressed: () {
                launch("tel:${contacts.textNo}");
              },
                  icon: Icon(Icons.call),
                  label: Text('Call')),
            ]
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
          centerTitle: true,
        ),//AppBar,
        body:  Column(
           children: contact.map((contacts) => contactTemplate(contacts)).toList()),
    );//Scaffold;
  }
}
