import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

class AddCoursePage extends StatefulWidget {
  AddCoursePage({Key key}) : super(key: key);

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  var courseIndices = [];
  String query = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    dataContainer.schedule.loadAllCourseData(online: true).then((data) {
      for (int i = 0; i < dataContainer.schedule.allCourses.length; i++) {
        courseIndices.add(i);
      }
      setState(() {
        loading = false;
      });
    });
  }

  void populateCourses() {
    if (query == '') {
      for (int i = 0; i < dataContainer.schedule.allCourses.length; i++) {
        courseIndices.add(i);
      }
      return;
    }
    courseIndices = [];
    for (int i = 0; i < dataContainer.schedule.allCourses.length; i++) {
      var course = dataContainer.schedule.allCourses[i];
      String searchString = course.courseName.replaceAll(' ', '');
      searchString += course.courseCode.replaceAll(' ', '');
      searchString = searchString.toLowerCase();
      if (searchString.contains(query)) {
        courseIndices.add(i);
      }
    }
  }

  void finalizeEnrolledCourses() {
    //TODO
    // this should create x events if there are x repititions in the calendar for that course.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: theme.appBarColor,
            elevation: 0,
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh, color: theme.iconColor),
                  onPressed: () {
                    dataContainer.schedule
                        .loadAllCourseData(online: true)
                        .then((data) {
                      setState(() {
                        loading = false;
                      });
                    });
                  }),
            ],
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.iconColor),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text("Add Courses",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textHeadingColor)),
          ),
          body: (loading == true)
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.search, color: theme.iconColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: theme.iconColor),
                            ),
                            hintText: 'Search'),
                        onChanged: (value) {
                          query = value;
                          populateCourses();
                          setState(() {});
                        },
                      ),
                      Expanded(
                        // height: ScreenSize.size.height,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            String courseName = dataContainer.schedule
                                .allCourses[courseIndices[index]].courseName;
                            String courseCode = dataContainer.schedule
                                .allCourses[courseIndices[index]].courseCode;
                            bool enrolled = dataContainer.schedule
                                .allCourses[courseIndices[index]].enrolled;
                            return Card(
                                color: (enrolled == true)
                                    ? theme.cardBgColor.withAlpha(30)
                                    : theme.cardBgColor,
                                child: InkWell(
                                  onTap: () {
                                    dataContainer
                                            .schedule
                                            .allCourses[courseIndices[index]]
                                            .enrolled =
                                        !dataContainer
                                            .schedule
                                            .allCourses[courseIndices[index]]
                                            .enrolled;
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: ScreenSize.size.width * 0.2,
                                          child: Text(courseCode,
                                              style: TextStyle(
                                                  color:
                                                      theme.textHeadingColor)),
                                        ),
                                        Container(
                                          width: ScreenSize.size.width * 0.6,
                                          child: Text(courseName,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color:
                                                      theme.textHeadingColor)),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          itemCount: courseIndices.length,
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
