import 'package:flutter/material.dart';
import 'package:instiapp/screens/homePage.dart';

class RepresentativePage extends StatefulWidget {
  @override
  _RepresentativePageState createState() => _RepresentativePageState();
}

class _RepresentativePageState extends State<RepresentativePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Know Your Representatives',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            children:
            representatives.map((card) => card.profileCard(context)).toList(),
          ),
        ),
      ),
    );
  }
}
