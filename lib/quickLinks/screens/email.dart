import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarColor,
          title: Text('Quick Links',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: theme.iconColor),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: dataContainer.quickLinks.emails
                .map<Widget>((currentobject) => Template(obj: currentobject))
                .toList(),
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
        color: theme.cardBgColor,
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
                  color: theme.textHeadingColor,
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
                    fontStyle: FontStyle.italic,
                    color: theme.textSubheadingColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
