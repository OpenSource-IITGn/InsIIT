import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/screens/classes/weekdaycard.dart';
import 'package:instiapp/screens/classes/contactcard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List<FoodCard> foodCards;
List<ContactCard> contactCards;

class _HomePageState extends State<HomePage> {
  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
  @override
  void initState() {
    super.initState();
    messData = loadMessData();
    importantContactData = loadImportantContactData();
  }

  Widget homeScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          'InstiApp',
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
                accountName: Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  'User Email',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            ListTile(
              title: Text('Important Contacts'),
              leading: Icon(
                Icons.contacts,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/importantcontacts');
              },
            ),
            ListTile(
              title: Text('Announcements'),
              leading: Icon(
                Icons.announcement,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/announcements');
              },
            ),
            ListTile(
              title: Text('Articles'),
              leading: Icon(
                Icons.art_track,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/articles');
              },
            ),
            ListTile(
              title: Text('Complaints'),
              leading: Icon(
                Icons.assignment_late,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/complaints');
              },
            ),
            ListTile(
              title: Text('Shuttle'),
              leading: Icon(
                Icons.airport_shuttle,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/shuttle');
              },
            ),
            ListTile(
              title: Text('Mess Menu'),
              leading: Icon(
                Icons.local_dining,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/messmenu');
              },
            ),
            ListTile(
              title: Text('Quicklinks'),
              leading: Icon(
                Icons.link,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Quicklinks');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Text(
              "What's in the ${selectMeal(foodCards)['meal']}?",
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
                          color: Colors.indigo[100],
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
    );
  }

  Widget loadScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('InstiApp'),
        centerTitle: true,
      ),
      body: Center(
        child: SpinKitChasingDots(
          color: Colors.indigo,
          size: 50.0,
        ),
      ),
    );
  }

  dynamic messDataList;
  Future<dynamic> messData;
  dynamic importantContactDataList;
  Future<dynamic> importantContactData;


  List monday = [];
  List tuesday = [];
  List wednesday = [];
  List thursday = [];
  List friday = [];
  List saturday = [];
  List sunday = [];


  makeList(List newDataList, {int num1 = 9, int num2 = 8, int num3 = 5, int num4 = 8}) {

    newDataList.removeAt(0);
    newDataList.removeAt(0);
    newDataList.removeAt(num1);
    newDataList.removeAt(num1);
    newDataList.removeAt(num1 + num2);
    newDataList.removeAt(num1 + num2);
    newDataList.removeAt(num1 + num2 + num3);
    newDataList.removeAt(num1 + num2 + num3);

    for (List l in newDataList) {
      monday+=[l[0]];
      tuesday+=[l[1]];
      wednesday+=[l[2]];
      thursday+=[l[3]];
      friday+=[l[4]];
      saturday+=[l[5]];
      sunday+=[l[6]];
    }

    monday = [monday.sublist(0, num1)] + [monday.sublist(num1, num1 + num2)] + [monday.sublist(num1 + num2, num1 + num2 + num3)] + [monday.sublist(num1 + num2 + num3)];
    tuesday = [tuesday.sublist(0, num1)] + [tuesday.sublist(num1, num1 + num2)] + [tuesday.sublist(num1 + num2, num1 + num2 + num3)] + [tuesday.sublist(num1 + num2 + num3)];
    wednesday = [wednesday.sublist(0, num1)] + [wednesday.sublist(num1, num1 + num2)] + [wednesday.sublist(num1 + num2, num1 + num2 + num3)] + [wednesday.sublist(num1 + num2 + num3)];
    thursday = [thursday.sublist(0, num1)] + [thursday.sublist(num1, num1 + num2)] + [thursday.sublist(num1 + num2, num1 + num2 + num3)] + [thursday.sublist(num1 + num2 + num3)];
    friday = [friday.sublist(0, num1)] + [friday.sublist(num1, num1 + num2)] + [friday.sublist(num1 + num2, num1 + num2 + num3)] + [friday.sublist(num1 + num2 + num3)];
    saturday = [saturday.sublist(0, num1)] + [saturday.sublist(num1, num1 + num2)] + [saturday.sublist(num1 + num2, num1 + num2 + num3)] + [saturday.sublist(num1 + num2 + num3)];
    sunday = [sunday.sublist(0, num1)] + [sunday.sublist(num1, num1 + num2)] + [sunday.sublist(num1 + num2, num1 + num2 + num3)] + [sunday.sublist(num1 + num2 + num3)];

  }

  loadMessData() async {

    messDataList = await sheet.getData('MessMenu!A:G');
    makeList(messDataList);

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
    importantContactDataList = await sheet.getData('Sheet1!A:B');

    contactCards = [
      ContactCard(name: importantContactDataList[0][0], contacts: importantContactDataList[0][1].split(',')),
      ContactCard(name: importantContactDataList[1][0], contacts: importantContactDataList[1][1].split(',')),
      ContactCard(name: importantContactDataList[2][0], contacts: importantContactDataList[2][1].split(',')),
      ContactCard(name: importantContactDataList[3][0], contacts: importantContactDataList[3][1].split(',')),
      ContactCard(name: importantContactDataList[4][0], contacts: importantContactDataList[4][1].split(',')),
      ContactCard(name: importantContactDataList[5][0], contacts: importantContactDataList[5][1].split(',')),
      ContactCard(name: importantContactDataList[6][0], contacts: importantContactDataList[6][1].split(',')),
      ContactCard(name: importantContactDataList[7][0], contacts: importantContactDataList[7][1].split(',')),
      ContactCard(name: importantContactDataList[8][0], contacts: importantContactDataList[8][1].split(',')),
    ];

    return importantContactDataList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([messData, importantContactData]),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loadScreen();
          case ConnectionState.waiting:
            return loadScreen();
          case ConnectionState.done:
            return homeScreen();
          default:
            return loadScreen();
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
