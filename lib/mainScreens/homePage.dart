import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/mainScreens/firsthomepage.dart';
import 'package:instiapp/mainScreens/loading.dart';
import 'package:instiapp/mainScreens/miscPage.dart';
import 'package:instiapp/map/screens/googlemap.dart';
import 'package:instiapp/shuttle/screens/shuttle.dart';
import 'package:instiapp/covid/screens/covidPage.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/bottomNavBar.dart';
import 'package:instiapp/utilities/constants.dart';

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

  void reloadData({forceRefresh = false}) {
    dataContainer.mess.getData(forceRefresh: forceRefresh).then((s) {
      mainPageLoading = false;
      setState(() {});
    });
    dataContainer.getOtherData(forceRefresh: forceRefresh);
  }

  PageController _pageController;
  List<String> titles = [
    "",
    // "News",
    "Buses",
    "Campus Map",
    "Covid Details",
    "Misc"
  ];

  Widget homeScreen() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.backgroundColor,
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: theme.bottomNavyBarColor,
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
            icon: Icon(Icons.apps, color: theme.textSubheadingColor),
            title: Text(
              'Home',
              style: TextStyle(color: theme.textSubheadingColor),
            ),
            activeColor: theme.bottomNavyBarIndicatorColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
          ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.rss_feed, color: theme.textSubheadingColor),
          //   title: Text(
          //     'Feed',
          //     style: TextStyle(color: theme.textSubheadingColor),
          //   ),
          //   activeColor: theme.bottomNavyBarIndicatorColor,
          //   inactiveColor: Colors.grey,
          //   textAlign: TextAlign.center,
          // ),
          BottomNavyBarItem(
            icon: Icon(Icons.airport_shuttle, color: theme.textSubheadingColor),
            title: Text(
              'Shuttle',
              style: TextStyle(color: theme.textSubheadingColor),
            ),
            activeColor: theme.bottomNavyBarIndicatorColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.map,
              color: theme.textSubheadingColor,
            ),
            textAlign: TextAlign.center,
            title: Text(
              'Map',
              style: TextStyle(color: theme.textSubheadingColor),
            ),
            activeColor: theme.bottomNavyBarIndicatorColor,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.announcement,
              color: theme.textSubheadingColor,
            ),
            textAlign: TextAlign.center,
            title: Text(
              'Covid',
              style: TextStyle(color: theme.textSubheadingColor),
            ),
            activeColor: theme.bottomNavyBarIndicatorColor,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.menu, color: theme.textSubheadingColor),
            title: Text(
              'Misc',
              style: TextStyle(color: theme.textSubheadingColor),
            ),
            textAlign: TextAlign.center,
            activeColor: theme.bottomNavyBarIndicatorColor,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            (darkMode) ? Icons.wb_sunny : Icons.wb_sunny_outlined,
            color: (darkMode) ? Colors.purple : Colors.black,
          ),
          onPressed: () {
            if (darkMode) {
              darkMode = false;
            } else {
              darkMode = true;
            }
            swapTheme(darkMode);
            setState(() {});
          },
        ),
        title: Container(
            decoration: new BoxDecoration(
                color: (titles[selectedIndex] == "")
                    ? Colors.transparent
                    : theme.backgroundColor.withAlpha(150),
                borderRadius: new BorderRadius.all(Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(titles[selectedIndex],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor)),
            )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.withAlpha(100)),
            onPressed: () {
              reloadData(forceRefresh: true);
              dataContainer.schedule.buildData();
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
          // FeedPage(),
          Shuttle(),
          MapPage(),
          CovidPage(),
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
      dataContainer.schedule.buildData();
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
