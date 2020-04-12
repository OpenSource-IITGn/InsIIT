import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          'InstiApp',
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
                accountName: Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  'User Email',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            ListTile(
              title: Text('Contacts'),
              leading: Icon(
                Icons.contacts,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contacts');
              },
            ),
            ListTile(
              title: Text('Announcements'),
              leading: Icon(
                Icons.announcement,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/announcements');
              },
            ),
            ListTile(
              title: Text('Articles'),
              leading: Icon(
                Icons.art_track,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/articles');
              },
            ),
            ListTile(
              title: Text('Complaints'),
              leading: Icon(
                Icons.assignment_late,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/complaints');
              },
            ),
          ],
        ),
      ),
    );
  }
}
