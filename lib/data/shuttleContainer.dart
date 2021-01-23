import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/shuttle/classes/buses.dart';
import 'package:instiapp/utilities/googleSheets.dart';

class ShuttleContainer {
  List<Buses> buses;

  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }

  getData({forceRefresh: false}) async {
    sheet.getData('BusRoutes!A:H', forceRefresh: forceRefresh).listen((cache) {
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
