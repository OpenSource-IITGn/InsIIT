import 'package:flutter/material.dart';
import 'package:instiapp/classes/scheduleModel.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {

  EventModel event;
  TextEditingController _courseIDController;
  TextEditingController _courseNameController;
  TextEditingController _locationController;
  TextEditingController _instructorsController;
  TextEditingController _creditsController;
  TextEditingController _preRequisiteController;

  void initState() {
    super.initState();
    _courseIDController = TextEditingController();
    _courseNameController = TextEditingController();
    _locationController = TextEditingController();
    _instructorsController = TextEditingController();
    _creditsController = TextEditingController();
    _preRequisiteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Course',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Course ID',
                ),
                controller: _courseIDController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Course Name',
                ),
                controller: _courseNameController,
              ),SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location (Optional)',
                ),
                controller: _locationController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Instructors (Optional)',
                ),
                controller: _instructorsController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Credit (Optional)',
                ),
                keyboardType: TextInputType.phone,
                controller: _creditsController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pre Requisite (Optional)',
                ),
                controller: _preRequisiteController,
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {

                },
                label: Text(
                    'Add Course',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
