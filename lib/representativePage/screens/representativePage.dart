import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/representativePage/classes/representatives.dart';
import 'package:instiapp/themeing/notifier.dart';

class RepresentativePage extends StatefulWidget {
  @override
  _RepresentativePageState createState() => _RepresentativePageState();
}

class _RepresentativePageState extends State<RepresentativePage> {
  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarColor,
        centerTitle: true,
        title: Text('Know Your Representatives',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
        iconTheme: IconThemeData(color: theme.iconColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            children: dataContainer.representatives.representatives
                .map<Widget>(
                    (Representative card) => card.profileCard(context, reload))
                .toList(),
          ),
        ),
      ),
    );
  }
}
