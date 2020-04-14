import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekDayCard {
  String day;

  WeekDayCard({this.day});

  Widget dayBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        day,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class FoodCard {
  String day;
  List<String> breakfast;
  List<String> lunch;
  List<String> snacks;
  List<String> dinner;

  FoodCard({this.day, this.breakfast, this.lunch, this.snacks, this.dinner});

}

class ItemModel {
  bool isExpanded;
  String header;
  List<String> bodyModel;

  ItemModel({this.isExpanded: false, this.header, this.bodyModel});

}


