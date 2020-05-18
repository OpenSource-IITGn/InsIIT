import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instiapp/screens/loading.dart';
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
List<Data> emails = [];
List<TodayCourse> todayCourses;
List<Course> _courses;
List<MyCourse> myCourses;
List<EventModel> removedEvents;

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
  }
  // var emails = [];
  loadlinks() async {
    sheet.getData('QuickLinks!A:C').listen((data) {
      var d = (data);
      d.forEach((i) {
        // int c = 0;
        // var t = i.split(',');
        emails.add(
          Data(
            descp: i[1][0],
            name: i[0][0], 
            email: i[2][0]
          ));
        // c++;
      });
    });
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

  loadRemovedCoursesData () async {
    getRemovedEventsData().listen((data) {
      print(data);
      removedEvents = makeRemovedEventsList(data);
    });
  }

  List<EventModel> makeRemovedEventsList (var removedEventsDataList) {
    List<EventModel> _removedEvents = [];

    if (removedEventsDataList != null && removedEventsDataList.length != 0) {
      removedEventsDataList.forEach((var lc) {
        if (lc[0] == 'course') {
          _removedEvents.add(EventModel(
            isCourse: true,
            courseId: lc[1],
            courseName: lc[2],
            eventType: lc[3],
          ));
        } else {
          _removedEvents.add(EventModel(
            isCourse: false,
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


  loadCourseData () async {
    sheet.getData('slots!A:F').listen((data) {
      todayCourses = makeTodayTimeSlotList(data);
    });
    _courses = listWithoutRepetitionCourse(courses);
    sheet.getData('timetable!A:Q').listen((data) {
      myCourses = makeMyCourseList(data, _courses);
    });
  }

  bool compareStrings(String str1, String str2) {
    if (str1.compareTo(str2) == 0) {
      return true;
    } else {
      return false;
    }
  }

  List<MyCourse> makeMyCourseList (List data, List<Course> _courses) {
    List<MyCourse> _myCourses = [];

    _courses.forEach((Course course) {
      bool mine = false;
      data.forEach((var lc) {
        if (mine == false && lc[0] != '-' && lc[0] != '' && lc[1] != '-' && lc[1] != '') {
          if (lc[0].replaceAll(' ', '').contains(new RegExp(
              course.name.replaceAll(' ', ''), caseSensitive: false)) ||
              course.name.replaceAll(' ', '').contains(new RegExp(
                  lc[0].replaceAll(' ', ''), caseSensitive: false)) ||
              compareStrings(course.name, lc[0]) ||
              lc[1].replaceAll(' ', '').contains(new RegExp(
                  course.name.replaceAll(' ', ''), caseSensitive: false)) ||
              course.name.replaceAll(' ', '').contains(new RegExp(
                  lc[1].replaceAll(' ', ''), caseSensitive: false)) ||
              compareStrings(course.name, lc[1])) {
            _myCourses.add(MyCourse(courseCode: lc[0],
                courseName: lc[1],
                noOfLectures: lc[2].toString(),
                noOfTutorials: lc[3].toString(),
                credits: lc[5].toString(),
                instructors: lc[6].split(','),
                preRequisite: lc[10],
                lectureCourse: lc[11].split('(')[0].replaceAll(' ', '').split('+'),
                lectureLocation: returnLocation(lc[11]),
                tutorialCourse: lc[12].split('(')[0].replaceAll(' ', '').split('+'),
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

  String returnLocation (var text) {
    if (text.split('(').length == 1) {
      return 'None';
    } else {
      return text.split('(')[1].replaceAll(')', '');
    }
  }

  List<TodayCourse> makeTodayTimeSlotList (var courseSlotDataList) {
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

  List<DateTime> returnTime (String time) {
    List<DateTime> seTime = [];
    DateTime today = DateTime.now();
    var list1 = time.split('-');
    var startString = list1[0].split(':');
    var endString = list1[1].split(':');
    seTime = [DateTime(today.year, today.month, today.day, int.parse(startString[0]), int.parse(startString[1])),
      DateTime(today.year, today.month, today.day, int.parse(endString[0]), int.parse(endString[1]))];

    return seTime;
  }

  List listWithoutRepetitionCourse (List<Course> courses) {
    List<Course> withoutRepeat = [];
    courses.forEach((Course course) {
      bool notHave = true;
      withoutRepeat.forEach((Course _course) {
        if (_course.id == course.id) {
          notHave = false;
        }
      });
      if (notHave) {
        withoutRepeat.add(course);
      }
    });
    return withoutRepeat;
  }

  loadImportantContactData() async {
    sheet.getData('Contacts!A:E').listen((data) {
      makeContactList(data);
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
      body: OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) {
          bool connected = connectivity != ConnectivityResult.none;
          if (connected != prevConnected) {
            reloadData();
            print("reloading");
            prevConnected = connected;
          }
          return new SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                  return Navigator.pushNamed(
                                      context, '/messmenu');
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
                RaisedButton(
                  child: Text("Daily Schedule"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/schedule');
                  },
                ),
                RaisedButton(
                  child: Text("Feed"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/feed');
                  },
                ),
              ],
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
