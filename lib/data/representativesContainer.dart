import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/representativePage/classes/representatives.dart';
import 'package:instiapp/utilities/globalFunctions.dart';
import 'dart:convert';

class RepresentativesContainer {
  List<Representative> representatives;

  getData() async {
    dataContainer.sheet.getData('Representatives!A:C').listen((data) {
      makeRepresentativeList(data);
    });
  }

  makeRepresentativeList(List representativeDataList) {
    representativeDataList.removeAt(0);
    representatives = [];
    for (List lc in representativeDataList) {
      List<String> batch = [];
      List listJsonData;
      listJsonData = jsonDecode(lc[2]);

      listJsonData.forEach((jsonData) {
        String currentBatch = jsonData["batch"];
        bool add = true;

        batch.forEach((String addedBatch) {
          if (addedBatch == currentBatch) {
            add = false;
          }
        });

        if (add) {
          batch.add(currentBatch);
        }
      });

      representatives.add(Representative(
          position: lc[0],
          description: lc[1],
          profiles: listJsonData,
          batch: batch,
          currentBatch: batch[0]));
    }
  }
}
