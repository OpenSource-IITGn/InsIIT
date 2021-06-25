import 'package:flutter/material.dart';
import 'package:instiapp/covid/classes/covidupdate.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/covid/classes/covidfaq.dart';
import 'dart:convert';

import 'package:instiapp/utilities/googleSheets.dart';

class CovidContainer {
  List<CovidFAQ> faqs;
  CovidUpdate updates;

  GSheet sheet = GSheet('1IvmgluIoPt8b7KOS2RWGTp1CtShhQLl-86k48g3_RWU');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }

  void getData({forceRefresh = false}) {
    getFaqData(forceRefresh: forceRefresh);
    getUpdateData(forceRefresh: forceRefresh);
  }

  getFaqData({forceRefresh = false}) async {
    sheet
        .getData('FAQs!A:B', forceRefresh: forceRefresh)
        .listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
      makeFAQList(data);
    });
  }

  makeFAQList(List faqDataList) {
    faqDataList.removeAt(0);
    faqs = [];
    for (List lc in faqDataList) {
      List listJsonData;
      listJsonData = jsonDecode(lc[1]);

      faqs.add(CovidFAQ(
          question: lc[0],
          answer: listJsonData));
    }
  }

  getUpdateData({forceRefresh = false}) async {
    sheet
        .getData('Updates!A:E', forceRefresh: forceRefresh)
        .listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
      makeUpdateList(data);
    });
  }

  makeUpdateList(List updateDataList) {
    updateDataList.removeAt(0);
    List listJsonData;
    listJsonData = jsonDecode(updateDataList[0][4]);
    updates = CovidUpdate(
      lastUpdate: updateDataList[0][0].toString(),
      activeCases: updateDataList[0][1].toString(),
      recoveredCases: updateDataList[0][2].toString(),
      primaryContacts: updateDataList[0][3].toString(),
      instructions: listJsonData,
    );
  }
}
