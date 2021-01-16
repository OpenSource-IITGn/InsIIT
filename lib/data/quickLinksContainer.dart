import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/quickLinks/screens/email.dart';
import 'package:instiapp/utilities/globalFunctions.dart';

class QuickLinksContainer {
  List<Data> emails;

  void getData() async {
    dataContainer.sheet.getData('QuickLinks!A:C').listen((data) {
      data.removeAt(0);
      emails = [];
      data.forEach((i) {
        emails.add(Data(descp: i[1], name: i[0], email: i[2]));
      });
    });
  }
}
