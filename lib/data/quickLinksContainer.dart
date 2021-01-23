import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/quickLinks/screens/email.dart';

class QuickLinksContainer {
  List<Data> emails;

  void getData({forceRefresh: false}) async {
    dataContainer.sheet
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
