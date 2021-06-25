import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';

class CovidFAQ {
  String question;
  List answer;

  CovidFAQ({
    this.question,
    this.answer});

  Widget answerCard(context, ansJson) {
    List tempList = ansJson["answer"];
    String heading = tempList[0];
    List<String> answers = [];
    for (int i = 1; i < tempList.length; i++) {
      answers.add(tempList[i]);
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
          children: answers
          .map((ans) {
            return Text(
              "• " + ans,
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

  Widget faqCard(context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textHeadingColor),
            ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 15, 25, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: answer
                    .map((ans) => answerCard(context, ans))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}