import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends StatefulWidget {
  @override
  _EventsCalendarState createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  Map<DateTime, List> _events;
  String description;
  List _selectedEvents;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay: ['Event 1', 'Event 2', 'Event 3', 'Event 4', 'Event 5', 'Event 6'],
    };

    description = '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa purus. Nulla facilisi. Pellentesque porttitor velit non enim facilisis, eu venenatis urna porta. Nulla facilisi. In eu pretium enim. Vivamus sed blandit sem. Mauris ultricies tristique tellus eu tempus.

Integer ornare non mi nec aliquet. Fusce lobortis magna id sollicitudin lobortis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Praesent interdum, massa aliquet bibendum ultricies, eros nibh blandit diam, vitae condimentum libero augue sit amet risus. Nulla vitae metus ut mauris venenatis tincidunt id at nisi. Quisque vel tortor gravida, semper ante efficitur, aliquam metus. Ut tincidunt ornare velit eget tincidunt. In hac habitasse platea dictumst. Proin rutrum quam in metus efficitur, sed lobortis quam hendrerit. Proin eu facilisis tellus, sit amet consectetur ante. In tempus, quam eu pellentesque ultrices, enim augue iaculis augue, at accumsan mi augue facilisis lacus. Aenean lacus tellus, pellentesque pretium ipsum ac, faucibus viverra libero. Mauris convallis tempus lobortis. Morbi ut lacinia magna. Sed mollis sollicitudin dignissim. Suspendisse sed sollicitudin massa, nec scelerisque massa.

Sed viverra quam ut lacus condimentum consequat. In elementum, purus et viverra pellentesque, erat justo rutrum magna, fermentum tempor odio justo ultrices nisi. Ut imperdiet lectus laoreet gravida ultricies. Vestibulum convallis turpis vel ante bibendum, eu dictum urna accumsan. In vulputate urna ac enim porta, vel vehicula mauris volutpat. Donec ac leo fermentum, scelerisque magna ac, egestas nulla. Curabitur sodales diam eget lacus fermentum faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In et ullamcorper orci. Sed sed cursus arcu. Suspendisse lobortis tortor non libero tincidunt blandit.''';

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Calendar"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: _buildTableCalendar()),
          SizedBox(height: 10.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return SingleChildScrollView(
      child: Container(
        child: TableCalendar(
          calendarController: _calendarController,
          events: _events,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            selectedColor: Colors.indigo,
            todayColor: Colors.orange,
            todayStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
            markersColor: Colors.blue,
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonDecoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20.0),
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.white,
            ),
            formatButtonShowsNext: false,
          ),
          onDaySelected: _onDaySelected,
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () {
            Navigator.pushNamed(context, '/eventpage', arguments: {
              'event': '$event',
              'description': description,
            });
          },
        ),
      ))
          .toList(),
    );
  }
}
