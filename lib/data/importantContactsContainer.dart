import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/importantContacts/classes/contactcard.dart';
import 'dart:convert';

import 'package:instiapp/utilities/googleSheets.dart';

class ImportantContactsContainer {
  List<ContactCard> contactCards;

  GSheet sheet = GSheet('1-WOQn_z9zCTokz9DXqT_LhJC4PRwOJB5Uf6HxwHrT-Q');
  Future<void> initializeCache() async {
    await sheet.initializeCache();
  }

  getData({forceRefresh: false}) async {
    sheet.getData('Contacts!A:E', forceRefresh: forceRefresh).listen((cache) {
      var data = [];
      for (int i = 0; i < cache.length; i++) {
        data.add(cache[i]);
      }
      makeContactList(data);
    });
  }

  makeContactList(List importantContactDataList) {
    importantContactDataList.removeAt(0);
    contactCards = [];
    for (List lc in importantContactDataList) {
      contactCards.add(ContactCard(
          name: lc[0], description: lc[1], contacts: jsonDecode(lc[2])));
    }
  }
}
