import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/faculty/classes/facultyCard.dart';
import 'package:instiapp/faculty/classes/facultyMember.dart';
import 'package:instiapp/themeing/notifier.dart';

/// A searchable directory of faculty and the offices they sit in.
///
/// Data comes from the sheet configured in `FacultyConfig`. Until a sheet is
/// set up, the screen explains what is missing instead of showing an error.
class FacultyDirectoryPage extends StatefulWidget {
  @override
  _FacultyDirectoryPageState createState() => _FacultyDirectoryPageState();
}

class _FacultyDirectoryPageState extends State<FacultyDirectoryPage> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Pull the latest list when the screen opens.
    dataContainer.faculty.getData();
  }

  @override
  Widget build(BuildContext context) {
    final bool configured = dataContainer.faculty.isConfigured;
    final List<FacultyMember> members = dataContainer.faculty.faculty
        .where((FacultyMember member) => member.matches(_query))
        .toList();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: theme.appBarColor,
        title: Text(
          'Faculty Offices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textHeadingColor,
          ),
        ),
        iconTheme: IconThemeData(color: theme.iconColor),
      ),
      body: !configured
          ? _message(
              Icons.info_outline,
              'Faculty data is not set up yet',
              'This directory reads from a Google Sheet. Once the team adds '
                  'the faculty sheet, offices will appear here.',
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    style: TextStyle(color: theme.textHeadingColor),
                    decoration: InputDecoration(
                      hintText: 'Search by name, department or office',
                      hintStyle: TextStyle(color: theme.textSubheadingColor),
                      prefixIcon: Icon(Icons.search, color: theme.iconColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: members.isEmpty
                      ? _message(
                          Icons.search_off,
                          'No matches',
                          _query.isEmpty
                              ? 'No faculty found yet. Please try again later.'
                              : 'No one matches "$_query".',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: members.length,
                          itemBuilder: (context, index) =>
                              FacultyCard(members[index]).build(context),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _message(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48, color: theme.iconColorLite),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textHeadingColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: theme.textSubheadingColor),
            ),
          ],
        ),
      ),
    );
  }
}
