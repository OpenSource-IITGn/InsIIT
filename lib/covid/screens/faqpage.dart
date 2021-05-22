import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/covid/classes/covidfaq.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('FAQs',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            children: dataContainer.covid.faqs
                .map<Widget>((CovidFAQ faq) => faq.faqCard(context))
                .toList(),
          ),
        ),
      ),
    );
  }
}
