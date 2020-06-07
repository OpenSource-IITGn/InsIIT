import 'package:flutter/material.dart';
import 'package:instiapp/classes/weekdaycard.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'dart:math' as math;
//TODO: AUTOMATICALLY EXPAND MENU FOR NEXT MEAL IN THIS PAGE
//TODO: THE CODE CAN BE COMPRESSED A LOT!!!! USE LIST<LIST>
//TODO : State for upvote and downvote

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
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(item.timeString,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withAlpha(150),
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
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: IconButton(
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 20,
                            color: Colors.black45,
                            onPressed: () {
                              sheet.writeData([
                                [
                                  DateTime.now().toString(),
                                  DateTime.now().weekday,
                                  food,
                                  '1'
                                ]
                              ], 'messFeedbackItems!A:D');
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 20,
                          color: Colors.black45,
                          onPressed: () {
                            sheet.writeData([
                              [
                                DateTime.now().toString(),
                                DateTime.now().weekday,
                                food,
                                '-1'
                              ]
                            ], 'messFeedbackItems!A:D');
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
        header: 'Snack',
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
        header: 'Snack',
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
        header: 'Snack',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[5].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '8:00 am to 10:00 am',
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
        header: 'Snack',
        timeString: '12:15 pm to 2:15 pm',
        bodyModel: foodCards[6].lunch),
    ItemModel(
        header: 'Snack',
        timeString: '8:00 am to 10:00 am',
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
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Mess Menu',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.transparent,
              unselectedLabelStyle:
                  TextStyle(color: Colors.black.withAlpha(150)),
              indicatorColor: Colors.black.withAlpha(150),
              tabs: <Widget>[
                WeekDayCard(day: 'Monday').dayBar(),
                WeekDayCard(day: 'Tueday').dayBar(),
                WeekDayCard(day: 'Wednesday').dayBar(),
                WeekDayCard(day: 'Thursday').dayBar(),
                WeekDayCard(day: 'Friday').dayBar(),
                WeekDayCard(day: 'Saturday').dayBar(),
                WeekDayCard(day: 'Sunday').dayBar(),
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
          color: Colors.black,
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
