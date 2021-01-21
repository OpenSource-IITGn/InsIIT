import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/schedule/classes/courseClass.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

class AddCoursePage extends StatefulWidget {
  AddCoursePage({Key key}) : super(key: key);

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  var thisTheme = theme;
  var courseIndices = [];
  List coursesToEnroll = [];
  String query = '';
  bool loading = true;
  void refresh() {
    setState(() {
      loading = true;
    });
    dataContainer.schedule.getAllCourses(forceRefresh: true).then((data) {
      for (int i = 0; i < dataContainer.schedule.allCourses.length; i++) {
        courseIndices.add(i);
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void populateCourses() {
    courseIndices = [];
    if (query == '') {
      for (int i = 0; i < dataContainer.schedule.allCourses.length; i++) {
        courseIndices.add(i);
      }
      return;
    }

    for (int i = 0; i < dataContainer.schedule.allCourses.length; i++) {
      Course course = dataContainer.schedule.allCourses[i];
      String searchString = course.name.replaceAll(' ', '');
      searchString += course.code.replaceAll(' ', '');
      searchString = searchString.toLowerCase();
      if (searchString.contains(query)) {
        courseIndices.add(i);
      }
    }
  }

  var _controller = TextEditingController();
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
                    refresh();
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: thisTheme.floatingColor,
            onPressed: () {
              loading = true;
              setState(() {});
              for (int i = 0; i < coursesToEnroll.length; i++) {
                print(coursesToEnroll[i]);
                dataContainer.schedule
                    .enrollCourseFromIndex(coursesToEnroll[i], true);
              }
              dataContainer.schedule.storeEnrolledCourses();
              loading = false;
              Navigator.pop(context);
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          body: (loading == true)
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: theme.iconColor,
                ))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        style: TextStyle(color: theme.textHeadingColor),
                        controller: _controller,
                        decoration: InputDecoration(
                            icon: Icon(Icons.search, color: theme.iconColor),
                            // fillColor: theme.iconColor,
                            suffixIcon: IconButton(
                              onPressed: () {
                                query = '';
                                populateCourses();
                                _controller.clear();
                                setState(() {});
                              },
                              icon: Icon(Icons.clear),
                            ),
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
                            String courseName = dataContainer
                                .schedule.allCourses[courseIndices[index]].name;
                            String courseCode = dataContainer
                                .schedule.allCourses[courseIndices[index]].code;
                            bool enrolled = dataContainer.schedule
                                .allCourses[courseIndices[index]].enrolled;
                            return Card(
                                color: (enrolled == true)
                                    ? theme.cardBgColor.withAlpha(30)
                                    : theme.cardBgColor,
                                child: InkWell(
                                  onTap: () {
                                    bool enrollment = !dataContainer
                                        .schedule
                                        .allCourses[courseIndices[index]]
                                        .enrolled;
                                    dataContainer
                                        .schedule
                                        .allCourses[courseIndices[index]]
                                        .enrolled = enrollment;
                                    if (enrollment == true) {
                                      coursesToEnroll.add(courseIndices[index]);
                                    } else {
                                      coursesToEnroll
                                          .remove(courseIndices[index]);
                                    }
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
