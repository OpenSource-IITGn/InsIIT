import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/messMenu/classes/weekdaycard.dart';
import 'package:instiapp/utilities/googleSheets.dart';

class MessContainer {
  List<List<ItemModel>> messItems;
  List<FoodCard> foodCards;
  List<List<dynamic>> allDayMessList;
  Map<String, String> foodIllustration;
  List<List<dynamic>> foodVotes;
  Map foodItems;

  GSheet sheet = GSheet('1shyZ4dzs1Txug1E2dsnH15lO5DF7g9oh5Rkuatxa3TY');

  Box messCache;

  Map<int, String> weekDays = {
    0: 'Monday',
    1: 'Tuesday',
    2: 'Wednesday',
    3: 'Thursday',
    4: 'Friday',
    5: 'Saturday',
    6: 'Sunday'
  };

  void getData({forceRefresh: false}) async {
    loadMessData(forceRefresh: forceRefresh);
    loadFoodVotesData();
    loadFoodIllustrationData(forceRefresh: forceRefresh);
  }

  Future<void> initializeCache() async {
    messCache = await Hive.openBox('mess');
    await sheet.initializeCache();
  }

  void loadMessData({forceRefresh: false}) async {
    sheet.getData('MessMenu!A:G', forceRefresh: forceRefresh).listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
      //print("Offline FoodItems!A:B = $data");
      int num1 = (data[0][0] is int) ? data[0][0] : int.parse(data[0][0]);
      int num2 = (data[0][1] is int) ? data[0][1] : int.parse(data[0][1]);
      int num3 = (data[0][2] is int) ? data[0][2] : int.parse(data[0][2]);
      int num4 = (data[0][3] is int) ? data[0][3] : int.parse(data[0][3]);
      data.removeAt(0);
      makeMessList(data, num1, num2, num3, num4);
      foodCards = [];

      for (var i = 0; i < 7; i++) {
        foodCards.add(FoodCard(
            day: weekDays[i],
            breakfast: allDayMessList[i][0],
            lunch: allDayMessList[i][1],
            snacks: allDayMessList[i][2],
            dinner: allDayMessList[i][3]));
      }
      log('Retrieved ${foodCards.length} food items', name: "MESS");
      selectMeal();
    });
  }

  void makeMessList(var messDataList, int num1, int num2, int num3, int num4) {
    // num1 : Number of cells in breakfast, num2 : Number of cells in lunch, num3 : Number of cells in snacks, num4 : Number of cells in dinner.
    allDayMessList = [[], [], [], [], [], [], []];

    messDataList.removeAt(0);
    messDataList.removeAt(0);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2 + num3);
    messDataList.removeAt(num1 + num2 + num3);

    for (var lm in messDataList) {
      for (var i = 0; i < 7; i++) {
        allDayMessList[i] += [lm[i]];
      }
    }

    for (var i = 0; i < 7; i++) {
      allDayMessList[i] = [allDayMessList[i].sublist(0, num1)] +
          [allDayMessList[i].sublist(num1, num1 + num2)] +
          [allDayMessList[i].sublist(num1 + num2, num1 + num2 + num3)] +
          [allDayMessList[i].sublist(num1 + num2 + num3)];
    }
  }

  void loadFoodIllustrationData({forceRefresh: false}) async {
    foodIllustration = {};
    sheet.getData('FoodItems!A:B', forceRefresh: forceRefresh).listen((data) {
      if (data.length != 0) {
        data.removeAt(0);
        for (var lst in data) {
          foodIllustration.putIfAbsent(lst[0], () => lst[1]);
        }
      }
    });
  }

  void loadFoodVotesData() {
    var data = messCache.get('foodvotes');
    foodVotes = [];
    if (data != null && data.length != 0) {
      data.forEach((var lc) {
        foodVotes.add([lc[0], lc[1].toString()]);
      });
    }
  }

  void storeFoodVotes() {
    messCache.put('foodvotes', foodVotes);
  }

  void makeMessItems() {
    messItems = [[], [], [], [], [], [], []];

    for (var i = 0; i < 7; i++) {
      messItems[i] = [
        ItemModel(
            header: 'Breakfast',
            timeString: '7:30 am to 9:30 am',
            bodyModel: foodCards[i].breakfast),
        ItemModel(
            header: 'Lunch',
            timeString: '12:15 pm to 2:15 pm',
            bodyModel: foodCards[i].lunch),
        ItemModel(
            header: 'Snack',
            timeString: '4:30 pm to 6:00pm',
            bodyModel: foodCards[i].snacks),
        ItemModel(
            header: 'Dinner',
            timeString: '7:30 pm to 9:30 pm',
            bodyModel: foodCards[i].dinner),
      ];
    }
  }

  void selectMeal() {
    foodItems = {};
    int day = DateTime.now().weekday - 1;
    int hour = DateTime.now().hour;
    if (hour >= 4 && hour <= 10) {
      foodItems = {
        'meal': 'Breakfast',
        'list': foodCards[day].breakfast,
      };
    } else if (hour > 10 && hour <= 15) {
      foodItems = {
        'meal': 'Lunch',
        'list': foodCards[day].lunch,
      };
    } else if (hour > 15 && hour < 19) {
      foodItems = {
        'meal': 'Snacks',
        'list': foodCards[day].snacks,
      };
    } else {
      foodItems = {
        'meal': 'Dinner',
        'list': foodCards[day].dinner,
      };
    }
  }
}
