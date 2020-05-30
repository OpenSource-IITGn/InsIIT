import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/loading.dart';
import 'package:instiapp/utilities/bottomNavBar.dart';
import 'package:instiapp/utilities/carouselSlider.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:instiapp/classes/weekdaycard.dart';
import 'package:instiapp/classes/contactcard.dart';
import 'package:instiapp/classes/buses.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'email.dart';
import 'package:instiapp/classes/scheduleModel.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:instiapp/screens/signIn.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage(this.notifyParent);
  final Function() notifyParent;
  @override
  _HomePageState createState() => _HomePageState();
}

List<FoodCard> foodCards;
List<ContactCard> contactCards;
List<Buses> buses;
List<Data> emails;
List<TodayCourse> todayCourses;
List<MyCourse> myCourses;
List<EventModel> removedEvents;
List<EventModel> examCourses;

class _HomePageState extends State<HomePage> {
  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
  var startpos, endpos;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    reloadData();
  }

  void reloadData() {
    loadMessData();
    loadImportantContactData();
    loadShuttleData();
    loadCourseData();
    loadRemovedCoursesData();
    loadExamTimeTableData();
  }

  loadShuttleData() async {
    sheet.getData('BusRoutes!A:H').listen((data) {
      var shuttleDataList = data;
      buses = [];
      shuttleDataList.removeAt(0);
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
    });
  }

  loadExamTimeTableData() async {
    sheet.getData('ExamTimeTable!A:H').listen((data) {
      examCourses = makeMyExamCoursesList(data, coursesWithoutRepetition);
    });
  }

  List<EventModel> makeMyExamCoursesList(List data, List<Course> _courses) {
    List<EventModel> myExamCourses = [];

    _courses.forEach((Course course) {
      bool mine = false;
      var baseLc = data[3];
      data.forEach((var lc) {
        if (mine == false && lc.length > 3) {
          if (lc[0] != '' && lc[0] != '-' && lc[1] != '' && lc[1] != '-') {
            baseLc = lc;
          }
          if (lc[2] != '' && lc[2] != '-') {
            if (lc[2].replaceAll(' ', '').contains(new RegExp(
                    course.name.replaceAll(' ', ''),
                    caseSensitive: false)) ||
                course.name.replaceAll(' ', '').contains(new RegExp(
                    lc[2].replaceAll(' ', ''),
                    caseSensitive: false)) ||
                compareStrings(course.name, lc[2]) ||
                lc[3].replaceAll(' ', '').contains(new RegExp(
                    course.name.replaceAll(' ', ''),
                    caseSensitive: false)) ||
                course.name.replaceAll(' ', '').contains(new RegExp(
                    lc[3].replaceAll(' ', ''),
                    caseSensitive: false)) ||
                compareStrings(course.name, lc[3])) {
              List<DateTime> time = getTime(baseLc);
              myExamCourses.add(EventModel(
                isCourse: false,
                isExam: true,
                start: time[0],
                end: time[1],
                courseId: lc[2],
                courseName: lc[3],
                location: lc[5].toString(),
                rollNumbers: lc[7].toString(),
                eventType: 'Exam',
              ));
              mine = true;
            }
          }
        }
      });
    });

    return myExamCourses;
  }

  Map<String, int> monthData = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  List<DateTime> getTime(var baseLc) {
    int index = 1;

    var date = baseLc[0].split(',');
    var dayWithMonth = date[1].split(' ');
    if (dayWithMonth.length == 2) {
      index = 0;
    }
    int year = int.parse(date[2].replaceAll(' ', ''));
    int day = int.parse(dayWithMonth[index + 1].replaceAll(' ', ''));
    int month = monthData[dayWithMonth[index].replaceAll(' ', '')];
    var dayTime = baseLc[1].split('-');
    var startTime = dayTime[0].replaceAll(' ', '').split(':');
    var endTime = dayTime[1].replaceAll(' ', '').split(':');
    int startHour = int.parse(startTime[0]);
    int startMinute = int.parse(startTime[1].substring(0, 2));
    int endHour = int.parse(endTime[0]);
    int endMinute = int.parse(endTime[1].substring(0, 2));
    List<DateTime> time = [
      DateTime(year, month, day, startHour, startMinute),
      DateTime(year, month, day, endHour, endMinute)
    ];
    return time;
  }

  loadRemovedCoursesData() async {
    getRemovedEventsData().listen((data) {
      print(data);
      removedEvents = makeRemovedEventsList(data);
    });
  }

  List<EventModel> makeRemovedEventsList(var removedEventsDataList) {
    List<EventModel> _removedEvents = [];

    if (removedEventsDataList != null && removedEventsDataList.length != 0) {
      removedEventsDataList.forEach((var lc) {
        if (lc[0] == 'course') {
          _removedEvents.add(EventModel(
            isCourse: true,
            isExam: false,
            courseId: lc[1],
            courseName: lc[2],
            eventType: lc[3],
          ));
        } else if (lc[0] == 'exam') {
          _removedEvents.add(EventModel(
            isCourse: false,
            isExam: true,
            courseId: lc[1],
            courseName: lc[2],
            eventType: lc[3],
          ));
        } else {
          _removedEvents.add(EventModel(
            isCourse: false,
            isExam: false,
            description: lc[1],
            summary: lc[2],
            location: lc[3],
            creator: lc[4],
            remarks: lc[5],
          ));
        }
      });
    }

    return _removedEvents;
  }

  Future<File> _localFileForRemovedEvents() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = tempPath + 'removedCourses' + '.csv';
    return File(filename);
  }

  Stream<List<List<dynamic>>> getRemovedEventsData() async* {
    var file = await _localFileForRemovedEvents();
    bool exists = await file.exists();
    if (exists) {
      await file.open();
      String values = await file.readAsString();
      List<List<dynamic>> rowsAsListOfValues =
          CsvToListConverter().convert(values);
      // print("FROM LOCAL: ${rowsAsListOfValues[2]}");

      yield rowsAsListOfValues;
    } else {
      yield [];
    }
  }

  loadCourseData() async {
    sheet.getData('slots!A:F').listen((data) {
      todayCourses = makeTodayTimeSlotList(data);
    });

    sheet.getData('timetable!A:Q').listen((data) {
      myCourses = makeMyCourseList(data, coursesWithoutRepetition);
    });
  }

  bool compareStrings(String str1, String str2) {
    if (str1.compareTo(str2) == 0) {
      return true;
    } else {
      return false;
    }
  }

  List<MyCourse> makeMyCourseList(List data, List<Course> _courses) {
    List<MyCourse> _myCourses = [];

    _courses.forEach((Course course) {
      bool mine = false;
      data.forEach((var lc) {
        if (mine == false &&
            lc[0] != '-' &&
            lc[0] != '' &&
            lc[1] != '-' &&
            lc[1] != '') {
          if (lc[0].replaceAll(' ', '').contains(new RegExp(
                  course.name.replaceAll(' ', ''),
                  caseSensitive: false)) ||
              course.name.replaceAll(' ', '').contains(new RegExp(
                  lc[0].replaceAll(' ', ''),
                  caseSensitive: false)) ||
              compareStrings(course.name, lc[0]) ||
              lc[1].replaceAll(' ', '').contains(new RegExp(
                  course.name.replaceAll(' ', ''),
                  caseSensitive: false)) ||
              course.name.replaceAll(' ', '').contains(new RegExp(
                  lc[1].replaceAll(' ', ''),
                  caseSensitive: false)) ||
              compareStrings(course.name, lc[1])) {
            _myCourses.add(MyCourse(
                courseCode: lc[0],
                courseName: lc[1],
                noOfLectures: lc[2].toString(),
                noOfTutorials: lc[3].toString(),
                credits: lc[5].toString(),
                instructors: lc[6].split(','),
                preRequisite: lc[10],
                lectureCourse:
                    lc[11].split('(')[0].replaceAll(' ', '').split('+'),
                lectureLocation: returnLocation(lc[11]),
                tutorialCourse:
                    lc[12].split('(')[0].replaceAll(' ', '').split('+'),
                tutorialLocation: returnLocation(lc[12]),
                labCourse: lc[13].split('(')[0].replaceAll(' ', '').split('+'),
                labLocation: returnLocation(lc[13]),
                remarks: lc[14],
                courseBooks: lc[15]));
            mine = true;
          }
        }
      });
    });

    return _myCourses;
  }

  String returnLocation(var text) {
    if (text.split('(').length == 1) {
      return 'None';
    } else {
      return text.split('(')[1].replaceAll(')', '');
    }
  }

  List<TodayCourse> makeTodayTimeSlotList(var courseSlotDataList) {
    int day = DateTime.now().weekday;
    List<TodayCourse> courses = [];
    if (day != 6 && day != 7) {
      courseSlotDataList.removeAt(0);
      courseSlotDataList.removeAt(0);

      courseSlotDataList.forEach((var lc) {
        List<DateTime> time = returnTime(lc[0]);
        courses.add(TodayCourse(start: time[0], end: time[1], course: lc[day]));
      });
    }
    return courses;
  }

  List<DateTime> returnTime(String time) {
    List<DateTime> seTime = [];
    DateTime today = DateTime.now();
    var list1 = time.split('-');
    var startString = list1[0].split(':');
    var endString = list1[1].split(':');
    seTime = [
      DateTime(today.year, today.month, today.day, int.parse(startString[0]),
          int.parse(startString[1])),
      DateTime(today.year, today.month, today.day, int.parse(endString[0]),
          int.parse(endString[1]))
    ];

    return seTime;
  }

  loadImportantContactData() async {
    sheet.getData('Contacts!A:E').listen((data) {
      makeContactList(data);
    });
  }

  loadlinks() async {
    sheet.getData('QuickLinks!A:C').listen((data) {
      var d = (data);
      emails = [];
      d.forEach((i) {
        int c = 0;
        var t = i[c].split(',');
        emails.add(Data(descp: t[1], name: t[0], email: t[2]));
        c++;
      });
    });
  }

  loadMessData() async {
    sheet.getData('MessMenu!A:G').listen((data) {
      makeMessList(data);
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
      loading = false;
      setState(() {});
    });
  }

  bool prevConnected = false;  
  int selectedIndex = 0;
  Widget homeScreen() {
    return Scaffold(
      // backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: selectedIndex,
        showElevation: true,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        onItemSelected: (index) {
          selectedIndex = index;
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
            icon: Icon(Icons.add_alert),
            title: Text('Booking'),
            textAlign: TextAlign.center,
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            widget.notifyParent();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.withAlpha(100)),
            onPressed: () {
              reloadData();
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.grey.withAlpha(100)),
            onPressed: () {
              reloadData();
            },
          )
        ],
        // title: Text('Institute App',
        //     style: TextStyle(
        //       fontFamily: 'OpenSans',
        //       // color: Colors.black,
        //       fontSize: 22,
        //     )),
        centerTitle: true,
      ),
      body: OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) {
          bool connected = connectivity != ConnectivityResult.none;
          if (connected != prevConnected) {
            reloadData();
            print("reloading");
            prevConnected = connected;
          }
          return new SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 60),
                  AnimatedContainer(
                    height: (connected) ? 0 : 24,
                    color: Color(0xFFEE4400),
                    duration: Duration(milliseconds: 500),
                    child: Center(
                      child: Text("Offline"),
                    ),
                  ),
                  (connected)
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          minRadius: 30,
                          child: ClipOval(
                              child: Image.network(
                            (gSignIn.currentUser == null)
                                ? ""
                                : gSignIn.currentUser.photoUrl,
                            fit: BoxFit.cover,
                            width: 90.0,
                            height: 90.0,
                          )),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (gSignIn.currentUser == null)
                                    ? "Hey John Doe!"
                                    : "Hey " +
                                        gSignIn.currentUser.displayName
                                            .split(' ')[0] +
                                        '!',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "How are you doing today? ",
                                style: TextStyle(
                                    color: Colors.black.withAlpha(150)),
                              ),
                              // Text(
                              //   "3 days to the weekend \uf601",
                              //   style: TextStyle(
                              //     fontSize: 12.0,
                              //     fontStyle: FontStyle.italic,
                              //       color: Colors.black.withAlpha(150)),
                              // ),
                            ]),
                      ]),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      return Navigator.pushNamed(context, '/messmenu');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Hungry?",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Here's what's in the mess",
                                    style: TextStyle(
                                        color: Colors.black.withAlpha(150)
                                        // fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                          SizedBox(height: 10),
                          CarouselSlider(
                            height: 100.0,
                            viewportFraction: 0.3,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            items:
                                selectMeal(foodCards)['list'].map<Widget>((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: 250.0,
                                    height: 120.0,
                                    child: Card(
                                      // color: primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Center(
                                          child: Text(
                                            i,
                                            style: TextStyle(
                                                // fontSize: 20.0,
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
                  ),
                  GestureDetector(
                    onTap: () {
                      return Navigator.pushNamed(context, '/schedule');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Wondering what's next?",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Here's your schedule",
                                    style: TextStyle(
                                        color: Colors.black.withAlpha(150)
                                        ),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      return Navigator.pushNamed(context, '/eventscalendar');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Bored?",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Checkout ongoing events",
                                    style: TextStyle(
                                        color: Colors.black.withAlpha(150)
                                        // fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                          SizedBox(height: 10),
                          CarouselSlider(
                            height: 300.0,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            items:
                                selectMeal(foodCards)['list'].map<Widget>((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    // color: Colors.black,
                                    child: Container(
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.black,
                                              height: 200.0,
                                              width: ScreenSize.size.width,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0),
                                                ),
                                                child: Image(
                                                  fit: BoxFit.cover,
                                                  height: 200.0,
                                                  // width: 300,
                                                  image: NetworkImage(
                                                      'https://assets.entrepreneur.com/content/3x2/2000/20191009140007-GettyImages-1053962188.jpeg'),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                          bottomLeft: const Radius
                                                              .circular(10.0),
                                                          bottomRight: const Radius
                                                              .circular(10.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 8, 8, 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment
                                                  //         .spaceAround,
                                                  children: <Widget>[
                                                    SizedBox(width: 10),
                                                    Column(
                                                      children: <Widget>[
                                                        Text("24",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            )),
                                                        Text('July')
                                                      ],
                                                    ),
                                                    verticalDivider(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "Photography Contest",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                        Text("Starts 7pm!",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withAlpha(
                                                                      150),
                                                              // fontWeight:
                                                              //     FontWeight.bold,
                                                              // fontSize: 16,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
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
                  ),

                  
                  // RaisedButton(
                  //   child: Text("Feed"),
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, '/feed');
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
        child: Container(),
      ),
    );
  }

  var monday = [];
  var tuesday = [];
  var wednesday = [];
  var thursday = [];
  var friday = [];
  var saturday = [];
  var sunday = [];

  makeMessList(var messDataList,
      {int num1 = 9, int num2 = 8, int num3 = 5, int num4 = 8}) {
    // num1 : Number of cells in breakfast, num2 : Number of cells in lunch, num3 : Number of cells in snacks, num4 : Number of cells in dinner.
    monday = [];
    tuesday = [];
    wednesday = [];
    thursday = [];
    friday = [];
    saturday = [];
    sunday = [];
    messDataList.removeAt(0);
    messDataList.removeAt(0);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2 + num3);
    messDataList.removeAt(num1 + num2 + num3);

    for (var lm in messDataList) {
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

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return loadScreen();
    } else {
      return homeScreen();
    }
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
