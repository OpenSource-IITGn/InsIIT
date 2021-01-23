import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/quickLinks/screens/email.dart';
import 'package:instiapp/utilities/googleSheets.dart';

class QuickLinksContainer {
  List<Data> emails;

  GSheet sheet = GSheet('1N4dgezGKBNR1Nh1EkjiKpaKs5YboR2rxjGx_I9yxwt4');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }

  void getData({forceRefresh = false}) async {
   sheet
        .getData('QuickLinks!A:C', forceRefresh: forceRefresh)
        .listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
      data.removeAt(0);
      emails = [];
      data.forEach((i) {
        emails.add(Data(descp: i[1], name: i[0], email: i[2]));
      });
    });
  }
}
