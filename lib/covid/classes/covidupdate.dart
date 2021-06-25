import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';

class CovidUpdate {
  String lastUpdate;
  String activeCases;
  String recoveredCases;
  String primaryContacts;
  List instructions;

  CovidUpdate({
    this.lastUpdate,
    this.activeCases,
    this.recoveredCases,
    this.primaryContacts,
    this.instructions});

  Widget instructionCard(context, insJson) {
    List tempList = insJson["instruction"];
    String heading = tempList[0];
    List<String> instructions = [];
    for (int i = 1; i < tempList.length; i++) {
      instructions.add(tempList[i]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (heading == "-")
        ? Container()
        : Center(
          child: Text(
            heading,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: theme.textHeadingColor),
          ),
        ),
        SizedBox(height: 4,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: instructions
              .map((ins) {
            return Text(
              "• " + ins,
              style: TextStyle(
                  color: theme.textHeadingColor),
            );
          })
              .toList(),
        ),
        Divider(),
      ],
    );
  }

  Widget updateCard(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.0, 15, 25, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Last Updated: ",
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: theme.textHeadingColor),
              ),
              Text(
                lastUpdate,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.textHeadingColor),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              Text(
                "Active Cases (Hostel Residents): ",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: theme.textHeadingColor),
              ),
              Text(
                activeCases,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            children: [
              Text(
                "Recovered Cases: ",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: theme.textHeadingColor),
              ),
              Text(
                recoveredCases,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            children: [
              Text(
                "Primary Contacts: ",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: theme.textHeadingColor),
              ),
              Text(
                primaryContacts,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Divider(),
        ] + instructions.map((ins) => instructionCard(context, ins)).toList(),
      ),
    );
  }
}