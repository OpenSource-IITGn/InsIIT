import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/shuttle/classes/buses.dart';
import 'package:instiapp/utilities/globalFunctions.dart';

class ShuttleContainer {
  List<Buses> buses;

  getData() async {
    dataContainer.sheet.getData('BusRoutes!A:H').listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
      var shuttleDataList = data;
      buses = [];
      shuttleDataList.removeAt(0);
      shuttleDataList.forEach((bus) {
        buses.add(Buses(
          origin: bus[0],
          destination: bus[1],
          time: bus[2],
          url: bus[4],
          hour: int.parse(bus[2].split(':')[0]),
          minute: int.parse(bus[2].split(':')[1]),
        ));
      });
    });
  }
}
