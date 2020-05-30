import 'package:flutter/material.dart';
import 'package:instiapp/classes/weekdaycard.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/utilities/constants.dart';
//TODO: AUTOMATICALLY EXPAND MENU FOR NEXT MEAL IN THIS PAGE
//TODO: THE CODE CAN BE COMPRESSED A LOT!!!! USE LIST<LIST>

/*

+25
First, it isn't recommended to not use elevation for ExpansionPanelList according to Material design spec.

However, if you really want to do that, there are 2 solutions for you, either you create your own custom ExpansionPanelList, or get ready to add couple of lines to the source file. I'm providing you the latter solution.

Open expansion_panel.dart file, go to the build() method of _ExpansionPanelListState and make following changes

return MergeableMaterial(
  hasDividers: true,
  children: items,
  elevation: 0, // 1st add this line
);
Now open mergeable_material.dart file, navigate to _paintShadows method of _RenderMergeableMaterialListBody class and make following changes:

void _paintShadows(Canvas canvas, Rect rect) {

  // 2nd add this line
  if (boxShadows == null) return;

  for (final BoxShadow boxShadow in boxShadows) {
    final Paint paint = boxShadow.toPaint();
    canvas.drawRRect(kMaterialEdges[MaterialType.card].toRRect(rect), paint);
  }
}


*/
class MessMenu extends StatefulWidget {
  @override
  _MessMenuState createState() => _MessMenuState();
}

List<ItemModel> monday = [
  ItemModel(
      header: 'Breakfast  -  8:00 am to 10:00 am',
      bodyModel: foodCards[0].breakfast),
  ItemModel(
      header: 'Lunch  -  12:15 pm to 2:15 pm', bodyModel: foodCards[0].lunch),
  ItemModel(
      header: 'Snacks  -  4:30 pm to 6:00 pm', bodyModel: foodCards[0].snacks),
  ItemModel(
      header: 'Dinner  -  7:30 pm to 9:30 pm', bodyModel: foodCards[0].dinner),
];

List<ItemModel> tuesday = [
  ItemModel(
      header: 'Breakfast  -  7:30 am to 9:30 am',
      bodyModel: foodCards[1].breakfast),
  ItemModel(
      header: 'Lunch  -  12:15 pm to 2:15 pm', bodyModel: foodCards[1].lunch),
  ItemModel(
      header: 'Snacks  -  4:30 pm to 6:00 pm', bodyModel: foodCards[1].snacks),
  ItemModel(
      header: 'Dinner  -  7:30 pm to 9:30 pm', bodyModel: foodCards[1].dinner),
];

List<ItemModel> wednesday = [
  ItemModel(
      header: 'Breakfast  -  7:30 am to 9:30 am',
      bodyModel: foodCards[2].breakfast),
  ItemModel(
      header: 'Lunch  -  12:15 pm to 2:15 pm', bodyModel: foodCards[2].lunch),
  ItemModel(
      header: 'Snacks  -  4:30 pm to 6:00 pm', bodyModel: foodCards[2].snacks),
  ItemModel(
      header: 'Dinner  -  7:30 pm to 9:30 pm', bodyModel: foodCards[2].dinner),
];

List<ItemModel> thursday = [
  ItemModel(
      header: 'Breakfast  -  7:30 am to 9:30 am',
      bodyModel: foodCards[3].breakfast),
  ItemModel(
      header: 'Lunch  -  12:15 pm to 2:15 pm', bodyModel: foodCards[3].lunch),
  ItemModel(
      header: 'Snacks  -  4:30 pm to 6:00 pm', bodyModel: foodCards[3].snacks),
  ItemModel(
      header: 'Dinner  -  7:30 pm to 9:30 pm', bodyModel: foodCards[3].dinner),
];

List<ItemModel> friday = [
  ItemModel(
      header: 'Breakfast  -  7:30 am to 9:30 am',
      bodyModel: foodCards[4].breakfast),
  ItemModel(
      header: 'Lunch  -  12:15 pm to 2:15 pm', bodyModel: foodCards[4].lunch),
  ItemModel(
      header: 'Snacks  -  4:30 pm to 6:00 pm', bodyModel: foodCards[4].snacks),
  ItemModel(
      header: 'Dinner  -  7:30 pm to 9:30 pm', bodyModel: foodCards[4].dinner),
];

List<ItemModel> saturday = [
  ItemModel(
      header: 'Breakfast  -  7:30 am to 9:30 am',
      bodyModel: foodCards[5].breakfast),
  ItemModel(
      header: 'Lunch  -  12:15 pm to 2:15 pm', bodyModel: foodCards[5].lunch),
  ItemModel(
      header: 'Snacks  -  4:30 pm to 6:00 pm', bodyModel: foodCards[5].snacks),
  ItemModel(
      header: 'Dinner  -  7:30 pm to 9:30 pm', bodyModel: foodCards[5].dinner),
];

List<ItemModel> sunday = [
  ItemModel(
      header: 'Breakfast - 7:30 am to 9:30 am',
      bodyModel: foodCards[6].breakfast),
  ItemModel(
      header: 'Lunch - 12:15 pm to 2:15 pm', bodyModel: foodCards[6].lunch),
  ItemModel(
      header: 'Snacks - 4:30 pm to 6:00 pm', bodyModel: foodCards[6].snacks),
  ItemModel(
      header: 'Dinner - 7:30 pm to 9:30 pm', bodyModel: foodCards[6].dinner),
];

Widget cardNew(foodList) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: foodList.map<Widget>((food) {
        if (food != '-') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                food,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        }
        return Container();
      }).toList(),
    ),
  );
}

Widget foodHead(name) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Text(
      name,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class _MessMenuState extends State<MessMenu> {
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
              unselectedLabelStyle: TextStyle(  color: Colors.black.withAlpha(150)),
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
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        monday[index].isExpanded = !monday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(monday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(monday[index].header);
                        },
                        isExpanded: monday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        tuesday[index].isExpanded = !tuesday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(tuesday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(tuesday[index].header);
                        },
                        isExpanded: tuesday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        wednesday[index].isExpanded =
                            !wednesday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(wednesday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(wednesday[index].header);
                        },
                        isExpanded: wednesday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        thursday[index].isExpanded =
                            !thursday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(thursday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(thursday[index].header);
                        },
                        isExpanded: thursday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        friday[index].isExpanded = !friday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(friday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(friday[index].header);
                        },
                        isExpanded: friday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        saturday[index].isExpanded =
                            !saturday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(saturday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(saturday[index].header);
                        },
                        isExpanded: saturday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionPanelList(
                    expansionCallback: (int item, bool status) {
                      setState(() {
                        sunday[index].isExpanded = !sunday[index].isExpanded;
                      });
                    },
                    animationDuration: Duration(seconds: 1),
                    children: [
                      ExpansionPanel(
                        body: Container(
                          padding: EdgeInsets.all(10.0),
                          child: cardNew(sunday[index].bodyModel),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return foodHead(sunday[index].header);
                        },
                        isExpanded: sunday[index].isExpanded,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: RaisedButton.icon(
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () {
            return Navigator.pushNamed(context, '/messfeedback');
          },
          icon: Icon(
            Icons.feedback,
            color: Colors.white,
          ),
          label: Text(
            'Feedback',
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
