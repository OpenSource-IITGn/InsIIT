import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/classes/weekdaycard.dart';
import 'package:instiapp/classes/contactcard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instiapp/classes/buses.dart';

class HomePage extends StatefulWidget {
  HomePage(this.notifyParent);
  final Function() notifyParent;
  @override
  _HomePageState createState() => _HomePageState();
}

List<FoodCard> foodCards;
List<ContactCard> contactCards;
List<Buses> buses;

class _HomePageState extends State<HomePage> {
  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
  var startpos, endpos;
  @override
  void initState() {
    super.initState();
    reloadData();
  }

  void reloadData() {
    messData = loadMessData();
    importantContactData = loadImportantContactData();
    shuttledata = loadShuttleData();
  }

  loadShuttleData() async {
    shuttleDataList = await sheet.getData('BusRoutes!A:H');
    buses = [];
    shuttleDataList.remove(0);
    shuttleDataList.forEach((bus) {
      buses.add(Buses(
        origin: bus[0],
        destination: bus[1],
        time: bus[2],
        url: bus[4],
        hour: int.parse(bus[2].split(':')[0]),
        minute: int.parse(bus[2].split(':')[1]),
      ));
    });
    return shuttleDataList;
  }

  Widget homeScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            widget.notifyParent();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              reloadData();
            },
          )
        ],
        title: Text(
          'InstiApp',
          style: TextStyle(fontFamily: 'OpenSans'),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: ScreenSize.size.height,
        child: Stack(
          children: <Widget>[
            Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  //INSERT OTHER WIDGETS HERE
                  Text(
                    "What's for ${selectMeal(foodCards)['meal']}?",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CarouselSlider(
                    height: 120.0,
                    viewportFraction: 0.6,
                    enlargeCenterPage: true,
                    items: selectMeal(foodCards)['list'].map<Widget>((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              return Navigator.pushNamed(context, '/messmenu');
                            },
                            child: Container(
                              width: 200.0,
                              height: 120.0,
                              child: Card(
                                // color: primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      i,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('InstiApp'),
        centerTitle: true,
      ),
      body: Center(
        child: SpinKitChasingDots(
          color: primaryColor,
          size: 50.0,
        ),
      ),
    );
  }

  dynamic messDataList;
  Future<dynamic> messData;
  dynamic importantContactDataList;
  Future<dynamic> importantContactData;
  dynamic shuttleDataList;
  Future<dynamic> shuttledata;

  List monday = [];
  List tuesday = [];
  List wednesday = [];
  List thursday = [];
  List friday = [];
  List saturday = [];
  List sunday = [];

  makeMessList(List messDataList,
      {int num1 = 9, int num2 = 8, int num3 = 5, int num4 = 8}) {
    // num1 : Number of cells in breakfast, num2 : Number of cells in lunch, num3 : Number of cells in snacks, num4 : Number of cells in dinner.

    messDataList.removeAt(0);
    messDataList.removeAt(0);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2 + num3);
    messDataList.removeAt(num1 + num2 + num3);

    for (List lm in messDataList) {
      monday += [lm[0]];
      tuesday += [lm[1]];
      wednesday += [lm[2]];
      thursday += [lm[3]];
      friday += [lm[4]];
      saturday += [lm[5]];
      sunday += [lm[6]];
    }

    monday = [monday.sublist(0, num1)] +
        [monday.sublist(num1, num1 + num2)] +
        [monday.sublist(num1 + num2, num1 + num2 + num3)] +
        [monday.sublist(num1 + num2 + num3)];
    tuesday = [tuesday.sublist(0, num1)] +
        [tuesday.sublist(num1, num1 + num2)] +
        [tuesday.sublist(num1 + num2, num1 + num2 + num3)] +
        [tuesday.sublist(num1 + num2 + num3)];
    wednesday = [wednesday.sublist(0, num1)] +
        [wednesday.sublist(num1, num1 + num2)] +
        [wednesday.sublist(num1 + num2, num1 + num2 + num3)] +
        [wednesday.sublist(num1 + num2 + num3)];
    thursday = [thursday.sublist(0, num1)] +
        [thursday.sublist(num1, num1 + num2)] +
        [thursday.sublist(num1 + num2, num1 + num2 + num3)] +
        [thursday.sublist(num1 + num2 + num3)];
    friday = [friday.sublist(0, num1)] +
        [friday.sublist(num1, num1 + num2)] +
        [friday.sublist(num1 + num2, num1 + num2 + num3)] +
        [friday.sublist(num1 + num2 + num3)];
    saturday = [saturday.sublist(0, num1)] +
        [saturday.sublist(num1, num1 + num2)] +
        [saturday.sublist(num1 + num2, num1 + num2 + num3)] +
        [saturday.sublist(num1 + num2 + num3)];
    sunday = [sunday.sublist(0, num1)] +
        [sunday.sublist(num1, num1 + num2)] +
        [sunday.sublist(num1 + num2, num1 + num2 + num3)] +
        [sunday.sublist(num1 + num2 + num3)];
  }

  makeContactList(List importantContactDataList) {
    importantContactDataList.removeAt(0);
    contactCards = [];
    for (List lc in importantContactDataList) {
      contactCards.add(ContactCard(
          name: lc[0],
          description: lc[1],
          contacts: lc[2].split(','),
          emails: lc[3].split(','),
          websites: lc[4].split(',')));
    }
  }

  loadMessData() async {
    messDataList = await sheet.getData('MessMenu!A:G');
    makeMessList(messDataList);

    foodCards = [
      FoodCard(
          day: 'Monday',
          breakfast: monday[0],
          lunch: monday[1],
          snacks: monday[2],
          dinner: monday[3]),
      FoodCard(
          day: 'Tuesday',
          breakfast: tuesday[0],
          lunch: tuesday[1],
          snacks: tuesday[2],
          dinner: tuesday[3]),
      FoodCard(
          day: 'Wednesday',
          breakfast: wednesday[0],
          lunch: wednesday[1],
          snacks: wednesday[2],
          dinner: wednesday[3]),
      FoodCard(
          day: 'Thursday',
          breakfast: thursday[0],
          lunch: thursday[1],
          snacks: thursday[2],
          dinner: thursday[3]),
      FoodCard(
          day: 'Friday',
          breakfast: friday[0],
          lunch: friday[1],
          snacks: friday[2],
          dinner: friday[3]),
      FoodCard(
          day: 'Saturday',
          breakfast: saturday[0],
          lunch: saturday[1],
          snacks: saturday[2],
          dinner: saturday[3]),
      FoodCard(
          day: 'Sunday',
          breakfast: sunday[0],
          lunch: sunday[1],
          snacks: sunday[2],
          dinner: sunday[3]),
    ];

    return messDataList;
  }

  loadImportantContactData() async {
    importantContactDataList = await sheet.getData('Contacts!A:E');
    makeContactList(importantContactDataList);

    return importantContactDataList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([messData, importantContactData, shuttledata]),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loadScreen();
          case ConnectionState.waiting:
            return homeScreen();
          case ConnectionState.done:
            return homeScreen();
          default:
            return homeScreen();
        }
      },
    );
  }

  Map selectMeal(List foodList) {
    int day = DateTime.now().weekday - 1;
    int hour = DateTime.now().hour;

    if (hour >= 4 && hour <= 10) {
      return {'meal': 'Breakfast', 'list': foodList[day].breakfast};
    } else if (hour > 10 && hour <= 15) {
      return {'meal': 'Lunch', 'list': foodList[day].lunch};
    } else if (hour > 15 && hour <= 19) {
      return {'meal': 'Snacks', 'list': foodList[day].snacks};
    } else {
      return {'meal': 'Dinner', 'list': foodList[day].dinner};
    }
  }
}
