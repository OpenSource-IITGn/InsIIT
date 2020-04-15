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

  Widget homeScreen () {
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
            SizedBox(height: 10.0,),
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

  Widget loadScreen () {
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

  dynamic dataList;
  dynamic data;

  loadData () async {
    dataList = await getData('A:F');

    foodCards =[
      FoodCard(day: 'Monday', breakfast: dataList[0][0].split(','), lunch: dataList[0][1].split(','), snacks: dataList[0][2].split(','), dinner: dataList[0][3].split(',')),
      FoodCard(day: 'Tuesday', breakfast: dataList[1][0].split(','), lunch: dataList[1][1].split(','), snacks: dataList[1][2].split(','), dinner: dataList[1][3].split(',')),
      FoodCard(day: 'Wednesday', breakfast: dataList[2][0].split(','), lunch: dataList[2][1].split(','), snacks: dataList[2][2].split(','), dinner: dataList[2][3].split(',')),
      FoodCard(day: 'Thursday', breakfast: dataList[3][0].split(','), lunch: dataList[3][1].split(','), snacks: dataList[3][2].split(','), dinner: dataList[3][3].split(',')),
      FoodCard(day: 'Friday', breakfast: dataList[4][0].split(','), lunch: dataList[4][1].split(','), snacks: dataList[4][2].split(','), dinner: dataList[4][3].split(',')),
      FoodCard(day: 'Saturday', breakfast: dataList[5][0].split(','), lunch: dataList[5][1].split(','), snacks: dataList[5][2].split(','), dinner: dataList[5][3].split(',')),
      FoodCard(day: 'Sunday', breakfast: dataList[6][0].split(','), lunch: dataList[6][1].split(','), snacks: dataList[6][2].split(','), dinner: dataList[6][3].split(',')),
    ];
    contactCards = [
      ContactCard(name: dataList[0][4], contacts: dataList[0][5].split(',')),
      ContactCard(name: dataList[1][4], contacts: dataList[1][5].split(',')),
      ContactCard(name: dataList[2][4], contacts: dataList[2][5].split(',')),
      ContactCard(name: dataList[3][4], contacts: dataList[3][5].split(',')),
      ContactCard(name: dataList[4][4], contacts: dataList[4][5].split(',')),
      ContactCard(name: dataList[5][4], contacts: dataList[5][5].split(',')),
      ContactCard(name: dataList[6][4], contacts: dataList[6][5].split(',')),
      ContactCard(name: dataList[7][4], contacts: dataList[7][5].split(',')),
      ContactCard(name: dataList[8][4], contacts: dataList[8][5].split(',')),
    ];
    return dataList;
  }

  @override
  void initState() {
    super.initState();
    data = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
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

  Map selectMeal (List foodList) {
    int day = DateTime.now().weekday - 1;
    int hour = DateTime.now().hour;

    if (hour >= 4 && hour <= 10) {
      return {'meal': 'Breakfast', 'list': foodList[day].breakfast};
    } else if (hour > 10 && hour <= 3) {
      return {'meal': 'Lunch', 'list': foodList[day].lunch};
    } else if (hour > 3 && hour <= 7) {
      return {'meal': 'Snacks', 'list': foodList[day].snacks};
    } else {
      return {'meal': 'Dinner', 'list': foodList[day].dinner};
    }
  }

}
