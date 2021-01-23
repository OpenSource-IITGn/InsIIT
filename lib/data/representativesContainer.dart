import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/representativePage/classes/representatives.dart';
import 'dart:convert';

import 'package:instiapp/utilities/googleSheets.dart';

class RepresentativesContainer {
  List<Representative> representatives;

  GSheet sheet = GSheet('1N5RLByi6APeTRrdYqzUnF14lZNDcl4rXSK407yFstj4');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }

  getData({forceRefresh = false}) async {
    sheet
        .getData('Representatives!A:C', forceRefresh: forceRefresh)
        .listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
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
