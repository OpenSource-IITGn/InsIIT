import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/covid/classes/covidfaq.dart';
import 'dart:convert';

import 'package:instiapp/utilities/googleSheets.dart';

class CovidContainer {
  List<CovidFAQ> faqs;

  GSheet sheet = GSheet('1IvmgluIoPt8b7KOS2RWGTp1CtShhQLl-86k48g3_RWU');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }

  getData({forceRefresh = false}) async {
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
}
