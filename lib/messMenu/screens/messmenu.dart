//(beta)import 'dart:convert';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Gaurav/Github_copy/Instiapp_Dev/IITGN-Institute-App/lib/messMenu/classes/weekdaycard.dart';
import 'package:instiapp/mainScreens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';

class MessMenu extends StatefulWidget {
  @override
  _MessMenuState createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  Widget foodHead(item) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.header,
            style: TextStyle(
              color: (darkMode) ? primaryTextColorDarkMode : primaryTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(item.timeString,
              style: TextStyle(
                  fontSize: 14,
                  color: (darkMode)
                      ? secondaryTextColorDarkMode
                      : secondaryTextColor,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget cardNew(foodList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: foodList.map<Widget>((food) {
          if (food != '-') {
            return Card(
              elevation: 0,
              color: Colors.blueAccent.withAlpha(5),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: ScreenSize.size.width * 0.6,
                      child: Text(
                        food,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: (darkMode)
                              ? primaryTextColorDarkMode
                              : primaryTextColor,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_down_alt),
                          iconSize: 20,
                          color: returnColorDownVote(food),
                          onPressed: () async {
                            setState(() {
                              String temp = '';
                              bool hasAlreadyVoted = false;
                              foodVotes.forEach((List<String> ls) {
                                if (ls[0] == food) {
                                  if (ls[1] == '1' || ls[1] == '0') {
                                    ls[1] = '-1';
                                    temp = '-1';
                                  } else {
                                    ls[1] = '0';
                                    temp = '0';
                                  }
                                  hasAlreadyVoted = true;
                                }
                              });

                              if (!hasAlreadyVoted) {
                                foodVotes.add([food, '-1']);
                                temp = '-1';
                              }
                              sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  DateTime.now().weekday,
                                  food,
                                  currentUser['email'],
                                  temp
                                ]
                              ], 'messFeedbackItems!A:D');
                            });
                            var file = await _localFile('foodVotes');
                            bool exists = await file.exists();
                            if (exists) {
                              await file.delete();
                            }
                            await file.create();
                            await file.open();
                            await file.writeAsString(
                                ListToCsvConverter().convert(foodVotes));
                            // print('DATA SAVED IN CACHE');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_up_alt),
                          iconSize: 20,
                          color: returnColorUpVote(food),
                          onPressed: () async {
                            setState(() {
                              String temp = '';
                              bool hasAlreadyVoted = false;
                              foodVotes.forEach((List<String> ls) {
                                if (ls[0] == food) {
                                  if (ls[1] == '-1' || ls[1] == '0') {
                                    ls[1] = '1';
                                    temp = '1';
                                  } else {
                                    ls[1] = '0';
                                    temp = '0';
                                  }
                                  hasAlreadyVoted = true;
                                }
                              });

                              if (!hasAlreadyVoted) {
                                foodVotes.add([food, '1']);
                                temp = '1';
                              }
                              sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  DateTime.now().weekday,
                                  food,
                                  currentUser['email'],
                                  temp
                                ]
                              ], 'messFeedbackItems!A:D');
                            });
                            var file = await _localFile('foodVotes');
                            bool exists = await file.exists();
                            if (exists) {
                              await file.delete();
                            }
                            await file.create();
                            await file.open();
                            await file.writeAsString(
                                ListToCsvConverter().convert(foodVotes));
                            // print('DATA SAVED IN CACHE');
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        }).toList(),
      ),
    );
  }

  static List<ItemModel> monday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '7:30 am to 9:30 am',
        bodyModel: foodCards[0].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[0].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[0].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[0].dinner),
  ];

  static List<ItemModel> tuesday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '8:00 am to 10:00 am',
        bodyModel: foodCards[1].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[1].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[1].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[1].dinner),
  ];

  static List<ItemModel> wednesday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '8:00 am to 10:00 am',
        bodyModel: foodCards[2].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[2].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[2].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[2].dinner),
  ];

  static List<ItemModel> thursday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '8:00 am to 10:00 am',
        bodyModel: foodCards[3].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[3].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[3].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[3].dinner),
  ];

  static List<ItemModel> friday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '8:00 am to 10:00 am',
        bodyModel: foodCards[4].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[4].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[4].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[4].dinner),
  ];

  static List<ItemModel> saturday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '8:00 am to 10:00 am',
        bodyModel: foodCards[5].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[5].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[5].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[5].dinner),
  ];

  static List<ItemModel> sunday = [
    ItemModel(
        header: 'Breakfast',
        timeString: '8:00 am to 10:00 am',
        bodyModel: foodCards[6].breakfast),
    ItemModel(
        header: 'Lunch',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[6].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '4:30 pm to 6:00pm',
        bodyModel: foodCards[6].snacks),
    ItemModel(
        header: 'Dinner',
        timeString: '7:30 pm to 9:30 pm',
        bodyModel: foodCards[6].dinner),
  ];
  List<List<ItemModel>> foodItems = [
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday
  ];

  Color returnColorUpVote(String food) {
    String vote = '0';
    if (foodVotes != null) {
      foodVotes.forEach((List<String> ls) {
        if (ls[0] == food) {
          vote = ls[1];
        }
      });
    }
    if (vote == '1') {
      return Colors.green;
    } else {
      return Colors.black45.withAlpha(50);
    }
  }

  Color returnColorDownVote(String food) {
    String vote = '0';
    if (foodVotes != null) {
      foodVotes.forEach((List<String> ls) {
        if (ls[0] == food) {
          vote = ls[1];
        }
      });
    }
    if (vote == '-1') {
      return Colors.red;
    } else {
      return Colors.black45.withAlpha(50);
    }
  }

  Future<File> _localFile(String range) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = tempPath + range + '.csv';
    return File(filename);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: DateTime.now().weekday - 1,
      length: 7,
      child: Scaffold(
        backgroundColor: (darkMode) ? backgroundColorDarkMode : backgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: (darkMode) ? navBarDarkMode : navBar,
          centerTitle: true,
          title: Text('Mess Menu',
              style: TextStyle(
                  color:
                      (darkMode) ? primaryTextColorDarkMode : primaryTextColor,
                  fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              indicatorColor: primaryColor,
              // unselectedLabelStyle:
              //     TextStyle(color: Colors.black.withOpacity(0.3)),
              tabs: <Widget>[
                Tab(text: 'Monday'),
                Tab(text: 'Tuesday'),
                Tab(
                  text: 'Wednesday',
                ),
                Tab(text: 'Thursday'),
                Tab(text: 'Friday'),
                Tab(
                  text: 'Saturday',
                ),
                Tab(
                  text: 'Sunday',
                ),
              ],
            ),
            preferredSize: Size.fromHeight(50.0),
          ),
        ),
        body: TabBarView(
          children: [0, 1, 2, 3, 4, 5, 6].map((e) {
            return Container(
              padding: EdgeInsets.all(0.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(.0),
                    child: Column(
                      children: <Widget>[
                        ExpansionTile(
                          title: foodHead(foodItems[e][index]),
                          children: <Widget>[
                            cardNew(foodItems[e][index].bodyModel),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
        floatingActionButton: RaisedButton.icon(
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          onPressed: () {
            return Navigator.pushNamed(context, '/messfeedback');
          },
          icon: Icon(
            Icons.rate_review,
            color: Colors.white,
          ),
          label: Text(
            'Review',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
