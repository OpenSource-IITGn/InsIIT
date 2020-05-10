
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:time_machine/time_machine.dart';
//import 'package:timetable/timetable.dart';
//import 'dart:math';
//
class AcademicCalendar extends StatefulWidget {
  @override
  _AcademicCalendarState createState() => _AcademicCalendarState();
}


// class _AcademicCalendarState extends State<AcademicCalendar> {

//  List<Color> colors = [Colors.blue, Colors.pink, Colors.yellow, Colors.orange, Colors.brown, Colors.green, Colors.lightBlueAccent];

//  TimetableController<BasicEvent> _controller;
//
//  @override
//  void initState() {
//    super.initState();
//    var randomNumberGenerator = Random();
//    _controller = TimetableController(
//      // A basic EventProvider containing a single event.
//      eventProvider: EventProvider.list([
//        BasicEvent(
//          id: 0,
//          title: 'My Course',
//          color: colors[randomNumberGenerator.nextInt(6)],
//          start: LocalDate.today().at(LocalTime(13, 0, 0)),
//          end: LocalDate.today().at(LocalTime(15, 0, 0)),
//        ),
//      ]),
//      initialDate: LocalDate.today(),
//      visibleRange: VisibleRange.days(7),
//      firstDayOfWeek: DayOfWeek.monday,
//    );
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic Calendar'),
      ),
//      body: Timetable<BasicEvent>(
//        controller: _controller,
//        eventBuilder: (event) => BasicEventWidget(event),
//      ),
    );
  }
}

