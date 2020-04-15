import 'package:flutter/material.dart';
import './contact.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  List<Contacts> contact = [
    Contacts (Name:'ABC',No: 9929676589,Textno:'9929676589' ),
    Contacts (Name:'ABC',No: 9929676589,Textno:'9929676589'),
    Contacts (Name:'ABC',No: 9929676589,Textno:'9929676589'),
    Contacts (Name:'XYZ',No: 9929676589,Textno:'9929676589'),


  ];

  Widget contacttemplate(Contacts) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(Contacts.Name,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 6.0,),
              Text(Contacts.Textno,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              RaisedButton.icon(onPressed: () {
                launch("tel:${Contacts.No}");
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
           children: contact.map((Contacts) => contacttemplate(Contacts)).toList()),
    );//Scaffold;
  }
}
