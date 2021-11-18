import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';
// import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

// import 'package:hive/hive.dart';
var x = "";

IconData getIcon(_value) {
  if (_value == "Jaiswal") {
    return (Icons.arrow_upward_rounded);
  } else {
    return (Icons.arrow_downward_rounded);
  }
}

class MessMenu extends StatefulWidget {
  @override
  _MessMenuState createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  String dropdownValue = 'MOHANI';

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
                color: theme.textHeadingColor),
          ),
          Text(item.timeString,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.textSubheadingColor))
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
              color: theme.cardAccent,
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
                            fontSize: 16.0, color: theme.textHeadingColor),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down_alt,
                          ),
                          iconSize: 20,
                          color: returnColorDownVote(food),
                          onPressed: () async {
                            setState(() {
                              String temp = '';
                              bool hasAlreadyVoted = false;
                              dataContainer.mess.foodVotes
                                  .forEach((List<dynamic> ls) {
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
                              dataContainer.mess.sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  x,
                                  DateTime.now().weekday,
                                  food,
                                  temp
                                ]
                              ], 'messFeedbackItems!A:D');
                            });
                            dataContainer.mess.storeFoodVotes();
                          },
                        ),
                        // DropdownButton<String>(
                        //   value: dropdownValue,
                        //   icon: const Icon(
                        //     Icons.thumb_down_alt,
                        //   ),
                        //   iconSize: 20,
                        //   elevation: 16,
                        //   focusColor: Colors.green,
                        //   style: const TextStyle(color: Colors.deepPurple),
                        //   underline: Container(
                        //     height: 2,
                        //     color: Colors.deepPurpleAccent,
                        //   ),
                        //   onChanged: (String newValue) {
                        //     setState(() {
                        //       dropdownValue = newValue;
                        //       String temp = '';
                        //       bool hasAlreadyVoted = false;
                        //       dataContainer.mess.foodVotes
                        //           .forEach((List<dynamic> ls) {
                        //         if (ls[0] == food) {
                        //           if (ls[1] == '-1' || ls[1] == '0') {
                        //             ls[1] = '1';
                        //             temp = '1';
                        //           } else {
                        //             ls[1] = '0';
                        //             temp = '0';
                        //           }
                        //           hasAlreadyVoted = true;
                        //         }
                        //       });

                        //       if (!hasAlreadyVoted) {
                        //         dataContainer.mess.foodVotes.add([food, '1']);
                        //         temp = '1';
                        //       }
                        //       dataContainer.mess.sheet.writeData([
                        //         [
                        //           DateTime.now().toString(),
                        //           DateTime.now().weekday,
                        //           food,
                        //           dropdownValue,
                        //           temp
                        //         ]
                        //       ], 'messFeedbackItems!A:D');
                        //     });
                        //     dataContainer.mess.storeFoodVotes();
                        //   },
                        //   items: <String>['L', 'U']
                        //       .map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        // ),

                        IconButton(
                          icon: Icon(
                            Icons.thumb_up_alt,
                          ),
                          iconSize: 20,
                          color: returnColorUpVote(food),
                          onPressed: () {
                            setState(() {
                              String temp = '';
                              bool hasAlreadyVoted = false;
                              dataContainer.mess.foodVotes
                                  .forEach((List<dynamic> ls) {
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
                              print("--------------------");
                              print("DUN DUN DUN");
                              dataContainer.mess.sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  x,
                                  DateTime.now().weekday,
                                  food,
                                  temp
                                ]
                              ], 'messFeedbackItems!A:D');
                            });
                            dataContainer.mess.storeFoodVotes();
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
      dataContainer.mess.foodVotes.forEach((List<dynamic> ls) {
        if (ls[0] == food) {
          vote = ls[1];
        }
      });
    }
    if (vote == '1') {
      return theme.upvoteColor;
    } else {
      return theme.iconColorLite;
    }
  }

  Color returnColorDownVote(String food) {
    String vote = '0';
    if (dataContainer.mess.foodVotes != null) {
      dataContainer.mess.foodVotes.forEach((List<dynamic> ls) {
        if (ls[0] == food) {
          vote = ls[1];
        }
      });
    }
    if (vote == '-1') {
      return theme.downvoteColor;
    } else {
      return theme.iconColorLite;
    }
  }

  String _value = "";
  List<String> _list = ["Mohani", "Jaiswal"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: DateTime.now().weekday - 1,
      length: 7,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.appBarColor,
          //Back Button
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          centerTitle: true,
          title: Text(
            "Mess Menu    ",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          // DropdownButton<String>(
          //   value: dropdownValue,
          //   // icon: const Icon(
          //   //   Icons.food_bank,
          //   // ),
          //   // iconSize: 30,
          //   // elevation: 100,
          //   focusColor: Colors.green,
          //   style: const TextStyle(
          //       color: Colors.deepPurple,
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold,
          //       fontFamily: 'OpenSans'),
          //   // underline: Container(
          //   //   height: 4,
          //   //   color: Colors.deepPurpleAccent,
          //   // ),
          //   onChanged: (String newValue) {
          //     setState(() {
          //       x = newValue;
          //       print("----------------------------------------------------");
          //       print(x);
          //       print(
          //           "--------------------------------------------------------");
          //       dropdownValue = newValue;
          //     });
          //   },
          //   items: <String>['MOHANI', 'JAISWAL']
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),

          actions: [
            PopupMenuButton(
                icon: Icon(
                  getIcon(_value),
                  size: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                elevation: 20,
                enabled: true,
                onSelected: (value) {
                  setState(() {
                    _value = value;
                  });
                },
                itemBuilder: (context) {
                  return _list.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text("$choice"),
                    );
                  }).toList();
                }),
            Padding(padding: EdgeInsets.all(0.4)),
            // Container(width: 50, child: Text("Mess", style: TextStyle(fontSize: 18.0))),
            // Icon(Icons.menu_book_rounded),
          ],
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: theme.textHeadingColor.withOpacity(0.3),
              indicatorColor: theme.indicatorColor,
              labelColor: theme.textHeadingColor,
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
          color: theme.floatingColor,
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
