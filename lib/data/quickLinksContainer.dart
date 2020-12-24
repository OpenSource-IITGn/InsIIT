import 'package:instiapp/quickLinks/screens/email.dart';
import 'package:instiapp/utilities/globalFunctions.dart';

class QuickLinksContainer {
  List<Data> emails;

  getData() async {
    sheet.getData('QuickLinks!A:C').listen((data) {
      var d = (data);
      d.removeAt(0);
      emails = [];
      d.forEach((i) {
        emails.add(Data(descp: i[1], name: i[0], email: i[2]));
      });
    });
  }
}