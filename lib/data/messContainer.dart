import 'package:instiapp/messMenu/classes/weekdaycard.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'package:csv/csv.dart';

class MessContainer {
  List<List<ItemModel>> messItems;
  List<FoodCard> foodCards;
  List<List<dynamic>> allDayMessList;
  Map<String, String> foodIllustration;
  List<List<String>> foodVotes;
  Map foodItems;

  Map<int, String> weekDays = {
    0: 'Monday',
    1: 'Tuesday',
    2: 'Wednesday',
    3: 'Thursday',
    4: 'Friday',
    5: 'Saturday',
    6: 'Sunday'
  };

  getData() async {
    loadMessData();
    loadFoodVotesData();
    loadFoodIllustrationData();
  }

  loadMessData() async {
    sheet.getData('MessMenu!A:G').listen((data) {
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
          dinner: allDayMessList[i][3]
        ));
      }

      selectMeal();
    });
  }

  makeMessList(var messDataList, int num1, int num2, int num3, int num4) {
    // num1 : Number of cells in breakfast, num2 : Number of cells in lunch, num3 : Number of cells in snacks, num4 : Number of cells in dinner.
    allDayMessList = [[],[],[],[],[],[],[]];

    messDataList.removeAt(0);
    messDataList.removeAt(0);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2);
    messDataList.removeAt(num1 + num2 + num3);
    messDataList.removeAt(num1 + num2 + num3);

    for (var lm in messDataList) {
      for (var i = 0; i < 7; i ++) {
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

  loadFoodIllustrationData() async {
    foodIllustration = {};
    sheet.getData('FoodItems!A:B').listen((data) {
      data.removeAt(0);
      for (var lst in data) {
        foodIllustration.putIfAbsent(lst[0], () => lst[1]);
      }
    });
  }

  loadFoodVotesData() async {
    getFoodVotesData().listen((data) {
      foodVotes = makeFoodVotesList(data);
    });
  }

  List<List<String>> makeFoodVotesList(var foodVotesList) {
    List<List<String>> _foodVotes = [];

    if (foodVotesList != null && foodVotesList.length != 0) {
      foodVotesList.forEach((var lc) {
        _foodVotes.add([lc[0], lc[1].toString()]);
      });
    }

    return _foodVotes;
  }

  Stream<List<List<dynamic>>> getFoodVotesData() async* {
    var file = await localFile('foodVotes');
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

  makeMessItems() {
    messItems = [[],[],[],[],[],[],[]];

    for (var i = 0; i < 7; i ++) {
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

  selectMeal() {
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
