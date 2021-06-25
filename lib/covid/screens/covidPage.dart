import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/covid/classes/covidfaq.dart';
import 'package:instiapp/covid/classes/covidupdate.dart';
import 'package:instiapp/themeing/notifier.dart';

class CovidPage extends StatefulWidget {
  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2, //TODO: Add Self Assessment Tab
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarColor,
          elevation: 0,
          bottom: PreferredSize(
            child: TabBar(
              unselectedLabelColor: theme.textHeadingColor.withOpacity(0.3),
              indicatorColor: theme.indicatorColor,
              labelColor: theme.textHeadingColor,
              // unselectedLabelStyle:
              //     TextStyle(color: Colors.black.withOpacity(0.3)),
              tabs: <Widget>[
                Tab(text: 'Updates'),
                Tab(text: 'FAQs'),
//                Tab(text: 'Self Assessment') //TODO: Add Self Assessment Tab
              ],
            ),
            preferredSize: Size.fromHeight(1.0),
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: dataContainer.covid.updates.updateCard(context),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  children: dataContainer.covid.faqs
                      .map<Widget>((CovidFAQ faq) => faq.faqCard(context))
                      .toList(),
                ),
              ),
            ),
//            Container(), //TODO: Add Self Assessment Tab
          ],
        ),
      ),
    );
  }
}
