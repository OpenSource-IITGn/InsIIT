import 'package:flutter/material.dart';
import 'package:instiapp/schedule/classes/scheduleModel.dart';
import 'package:instiapp/schedule/screens/editEvents.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

class CustomSearch extends SearchDelegate {
  var thisTheme = lightTheme;

  Widget courseCard(CourseModel course, Map<CourseModel, bool> add) {
    return GestureDetector(
      onTap: () {
        if (add[course]) {
          add[course] = false;
        } else {
          add[course] = true;
        }

        String temp = query;
        query = query + 'a';
        query = temp;
      },
      child: Container(
        width: ScreenSize.size.width * 1,
        child: Card(
          color: (add[course]) ? thisTheme.cardAccent : thisTheme.cardBgColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(course.courseCode,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: thisTheme.textHeadingColor))),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                    child: Text(
                  course.courseName,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //DONT REMOVE
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (loadingAddCourseData ||
        query == "gfufievkldnvodjsjvkdsnvklnviwehlekwdmcnewklvnlehvldkncken") {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (query.isEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: notAddedCourses.map<Widget>((CourseModel course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      );
    } else {
      final suggestionList = notAddedCourses
          .where((CourseModel course) => ((course.courseCode.toLowerCase())
                  .startsWith(query.toLowerCase()) ||
              (course.courseName.toLowerCase())
                  .startsWith(query.toLowerCase())))
          .toList();

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: suggestionList.map<Widget>((CourseModel course) {
              return courseCard(course, add);
            }).toList(),
          ),
        ),
      );
    }
  }
}
