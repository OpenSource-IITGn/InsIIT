import 'package:instiapp/representativePage/classes/representatives.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'dart:convert';

class RepresentativesContainer {
  List<Representative> representatives;

  getData() async {
    sheet.getData('Representatives!A:C').listen((data) {
      makeRepresentativeList(data);
    });
  }

  makeRepresentativeList(List representativeDataList) {
    representativeDataList.removeAt(0);
    representatives = [];
    for (List lc in representativeDataList) {
      representatives.add(Representative(
          position: lc[0], description: lc[1], profiles: jsonDecode(lc[2])));
    }
  }
}