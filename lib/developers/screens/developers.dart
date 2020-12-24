import 'package:flutter/material.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DevModel {
  String name;
  String description;
  String email;
  DevModel({this.name, this.description, this.email});
}

class DevelopersPage extends StatelessWidget {
  DevelopersPage({Key key}) : super(key: key);
  var devs = [
    DevModel(
        name: 'Praveen Venkatesh',
        description: 'B.Tech \'18',
        email: 'praveen.venkatesh@iitgn.ac.in'),
    DevModel(
        name: 'Chris Francis',
        description: 'B.Tech \'18',
        email: 'chris.francis@iitgn.ac.in'),
    DevModel(
        name: 'Nishikant Parmar',
        description: 'B.Tech \'18',
        email: 'nishikant.parmar@iitgn.ac.in'),
    DevModel(
        name: 'Gaurav Viramgami',
        description: 'B.Tech \'19',
        email: 'viramgami.g@iitgn.ac.in'),
    DevModel(
        name: 'Kritika Kumawat',
        description: 'B.Tech \'19',
        email: 'kritika.k@iitgn.ac.in'),
    DevModel(
        name: 'Anurag Kurle',
        description: 'B.Tech \'19',
        email: 'kurle.anurag@iitgn.ac.in')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (darkMode)?backgroundColorDarkMode:backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: (darkMode)?navBarDarkMode:navBar,
        centerTitle: true,
        title: Text('Team InsIIT',
            style: TextStyle(color: (darkMode)?primaryTextColorDarkMode:primaryTextColor, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ColumnBuilder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: ScreenSize.size.width,
              child: Card(
                  child: InkWell(
                onTap: () {
                  launch('mailto:${devs[index].email}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            devs[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: (darkMode)?primaryTextColorDarkMode:primaryTextColor),
                          ),
                          Text(
                            devs[index].description,
                            style:
                                TextStyle(color: (darkMode)?secondaryTextColorDarkMode:secondaryTextColor),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          verticalDivider(height: 30.0),
                          Icon(Icons.email),
                        ],
                      )
                    ],
                  ),
                ),
              )),
            );
          },
          itemCount: devs.length,
        ),
      )),
    );
  }
}
