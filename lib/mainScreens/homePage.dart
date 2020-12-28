import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instiapp/feed/screens/feedPage.dart';
import 'package:instiapp/mainScreens/firsthomepage.dart';
import 'package:instiapp/mainScreens/loading.dart';
import 'package:instiapp/map/screens/googlemap.dart';
import 'package:instiapp/shuttle/screens/shuttle.dart';

import 'package:instiapp/utilities/bottomNavBar.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/mainScreens/miscPage.dart';
import 'package:instiapp/data/dataContainer.dart';

class HomePage extends StatefulWidget {
  HomePage(this.notifyParent);
  final Function() notifyParent;
  @override
  _HomePageState createState() => _HomePageState();
}

bool mainPageLoading = true;
int selectedIndex = 0;
List<int> prevIndexes = [];

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  var startpos, endpos;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(selectedIndex);
      }
    });
    reloadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void reloadData() {
    dataContainer.mess.getData().then((s) {
      mainPageLoading = false;
      setState(() {});
    });
    dataContainer.getOtherData();
  }

  PageController _pageController;
  List<String> titles = ["", "News", "Buses", "Campus Map", "Misc"];

  Widget homeScreen() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: selectedIndex,
        showElevation: true,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        onItemSelected: (index) {
          selectedIndex = index;
          _pageController.jumpToPage(index);
          setState(() {});
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text('Feed'),
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text('Shuttle'),
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.map),
            textAlign: TextAlign.center,
            title: Text('Map'),
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.menu),
            title: Text('Misc'),
            textAlign: TextAlign.center,
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
//        leading: IconButton(
//          icon: Icon(
//            (darkMode) ? Icons.wb_sunny : Icons.wb_sunny_outlined,
//            color: (darkMode) ? Colors.purple : Colors.black,
//          ),
//          onPressed: () {
//            if (darkMode) {
//              darkMode = false;
//            } else {
//              darkMode = true;
//            }
//            Provider.of<ThemeNotifier>(context, listen: false)
//                .setTheme(darkMode);
//            setState(() {});
//          },
//        ),
        title: Container(
            decoration: new BoxDecoration(
                color: (titles[selectedIndex] == "")
                    ? Colors.transparent
                    : Colors.white.withAlpha(120),
                borderRadius: new BorderRadius.all(Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(titles[selectedIndex],
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.withAlpha(100)),
            onPressed: () {
              reloadData();
              dataContainer.schedule.readyEvents();
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.grey.withAlpha(100)),
            onPressed: () {
              dataContainer.auth.logoutUser().then((value) {
                Navigator.pushReplacementNamed(context, '/signin');
              });
            },
          )
        ],
        centerTitle: true,
      ),
      body: PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => selectedIndex = index);
        },
        children: <Widget>[
          MainHomePage(reloadData),
          FeedPage(),
          Shuttle(),
          MapPage(),
          MiscPage(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (mainPageLoading == true) {
      return loadScreen();
    } else {
      dataContainer.schedule.readyEvents();
      return WillPopScope(onWillPop: _onBackPressed, child: homeScreen());
    }
  }

  Future<bool> _onBackPressed() {
    if (selectedIndex != 0) {
      _pageController.jumpToPage(0);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
