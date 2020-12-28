import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:instiapp/data/dataContainer.dart';

class MessMenu extends StatefulWidget {
  @override
  _MessMenuState createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  void initState() {
    super.initState();
    dataContainer.mess.makeMessItems();
  }

  Widget foodHead(item) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.header,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(item.timeString,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
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
                              dataContainer.mess.foodVotes
                                  .forEach((List<String> ls) {
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
                                dataContainer.mess.foodVotes.add([food, '-1']);
                                temp = '-1';
                              }
                              sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  DateTime.now().weekday,
                                  food,
                                  dataContainer.auth.user.email,
                                  temp
                                ]
                              ], 'messFeedbackItems!A:D');
                            });
                            var file = await localFile('foodVotes');
                            bool exists = await file.exists();
                            if (exists) {
                              await file.delete();
                            }
                            await file.create();
                            await file.open();
                            await file.writeAsString(ListToCsvConverter()
                                .convert(dataContainer.mess.foodVotes));
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
                              dataContainer.mess.foodVotes
                                  .forEach((List<String> ls) {
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
                                dataContainer.mess.foodVotes.add([food, '1']);
                                temp = '1';
                              }
                              sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  DateTime.now().weekday,
                                  food,
                                  dataContainer.auth.user.email,
                                  temp
                                ]
                              ], 'messFeedbackItems!A:D');
                            });
                            var file = await localFile('foodVotes');
                            bool exists = await file.exists();
                            if (exists) {
                              await file.delete();
                            }
                            await file.create();
                            await file.open();
                            await file.writeAsString(ListToCsvConverter()
                                .convert(dataContainer.mess.foodVotes));
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

  Color returnColorUpVote(String food) {
    String vote = '0';
    if (dataContainer.mess.foodVotes != null) {
      dataContainer.mess.foodVotes.forEach((List<String> ls) {
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
    if (dataContainer.mess.foodVotes != null) {
      dataContainer.mess.foodVotes.forEach((List<String> ls) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: DateTime.now().weekday - 1,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title:
              Text('Mess Menu', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              // indicatorColor: primaryColor,
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
                          title:
                              foodHead(dataContainer.mess.messItems[e][index]),
                          children: <Widget>[
                            cardNew(dataContainer
                                .mess.messItems[e][index].bodyModel),
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
          // color: primaryColor,
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
