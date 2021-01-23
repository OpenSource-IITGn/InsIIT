import 'package:instiapp/utilities/googleSheets.dart';

class MapContainer {
  GSheet sheet = GSheet('1gbvHlslrNErxJzp9cgqMKgvxxRqERJm7_ZRZKiOad9o');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }
}
