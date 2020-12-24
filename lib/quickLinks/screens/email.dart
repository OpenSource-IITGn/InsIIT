import 'package:flutter/material.dart';
import 'package:instiapp/mainScreens/homePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:instiapp/utilities/constants.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  loadlinks() async {
    sheet.getData('QuickLinks!A:C').listen((data) {
      var d = (data);
      d.removeAt(0);
      emails = [];
      d.forEach((i) {
        emails.add(Data(descp: i[1], name: i[0], email: i[2]));
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    loadlinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: (darkMode)?backgroundColorDarkMode:backgroundColor,
        appBar: AppBar(
          title: Text('Quick Links',
              style:
                  TextStyle(color: (darkMode)?primaryTextColorDarkMode:primaryTextColor, fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: (darkMode)?navBarDarkMode:navBar,
        ),
        body: SingleChildScrollView(
          child: Column(
            // children: {template(emails[0])}.toList(),
            children: emails
                .map((currentobject) => Template(obj: currentobject))
                .toList(),

            //.toList across the whole emails.map(), since the children of coloumn need to be in list

            //since children property expects a list, adding .toList()
          ),
        ));
  }
}

class Data {
  String email;
  String name;
  String descp;

  Data({String email, String name, String descp}) {
    this.email = email;
    this.name = name;
    this.descp = descp;

    // Data({this.email, this.name}); // a way of writing the same as above
  }
}

class Template extends StatelessWidget {
  const Template({
    Key key,
    @required this.obj,
  }) : super(key: key);

  final obj;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var url = obj.email;

        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                obj.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: (darkMode)?primaryTextColorDarkMode:primaryTextColor,
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(obj.email, style: TextStyle(color: Colors.blue[600])),
              SizedBox(
                height: 6.0,
              ),
              Text(obj.descp,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: (darkMode)?secondaryTextColorDarkMode:secondaryTextColor,
                      fontStyle: FontStyle.italic))
            ],
          ),
        ),
      ),
    );
  }
}
