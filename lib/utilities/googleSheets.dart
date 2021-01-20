import 'dart:developer';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:hive/hive.dart';
import 'package:instiapp/credentials/credentials.dart'; // this has the credentials

class GSheet {
  //range in the form "sheetname!A:C" A:C is range of columns
  //data returned in the form of [[row], [row], [row], [row]]
  final scopes = [sheets.SheetsApi.SpreadsheetsScope];

  String spreadSheetID;
  Box cache;
  bool refreshNeeded;
  GSheet(
    String id,
  ) {
    this.spreadSheetID = id;
  }
  Future<void> initializeCache() async {
    cache = await Hive.openBox(spreadSheetID);
  }

  Future<void> forceClearCache() async {
    await cache.deleteFromDisk();
    cache = await Hive.openBox(spreadSheetID);
  }

  Future writeData(var data, String range) async {
    await auth.clientViaServiceAccount(credentials, this.scopes).then((client) {
      auth
          .obtainAccessCredentialsViaServiceAccount(
              credentials, this.scopes, client)
          .then((auth.AccessCredentials cred) {
        SheetsApi api = new SheetsApi(client);
        ValueRange vr = new sheets.ValueRange.fromJson({
          "values": data //data is [[row1],[row2], ...]
        });
        api.spreadsheets.values
            .append(vr, this.spreadSheetID, range,
                valueInputOption: 'USER_ENTERED')
            .then((AppendValuesResponse r) {
          client.close();
        });
      });
    });
  }

  bool isRefreshRequired() {
    if (refreshNeeded != null) {
      return refreshNeeded;
    }
    String lastRetrieved = cache.get('lastAccessed');
    if (lastRetrieved == null) {
      return true;
    }
    final lastAccessedDate = DateTime.parse(lastRetrieved);
    final now = DateTime.now();
    final difference = now.difference(lastAccessedDate).inDays;

    if (difference > 0) {
      refreshNeeded = true;
      log("It's been $difference days since last refreshed.", name: "SHEET");
    } else {
      refreshNeeded = false;
      log("Sheet refresh not needed", name: "SHEET");
    }

    return refreshNeeded;
  }

  Stream<List> getData(String range, {forceRefresh = false}) async* {
    var returnval;
    var data = cache.get(range);

    if (data != null && !forceRefresh) {
      log("Getting data at $range from cache", name: "SHEET");
      yield data;
    }

    if (forceRefresh || data == null || isRefreshRequired()) {
      log("Getting data at $range from internet", name: "SHEET");
      returnval = await getDataOnline(range);

      cache.put(range, returnval);
      cache.put('lastAccessed', DateTime.now().toString());
      yield returnval;
    }
  }

  Future<List> getDataOnline(String range) async {
    var returnval;
    await auth
        .clientViaServiceAccount(credentials, this.scopes)
        .then((client) async {
      await auth
          .obtainAccessCredentialsViaServiceAccount(
              credentials, this.scopes, client)
          .then((auth.AccessCredentials cred) async {
        SheetsApi api = new SheetsApi(client);
        await api.spreadsheets.values.get(this.spreadSheetID, range).then((qs) {
          returnval = qs.values;
        });
      });
    });
    return returnval;
  }

  Future updateData(var data, String range) async {
    await auth.clientViaServiceAccount(credentials, this.scopes).then((client) {
      auth
          .obtainAccessCredentialsViaServiceAccount(
              credentials, this.scopes, client)
          .then((auth.AccessCredentials cred) {
        SheetsApi api = new SheetsApi(client);

        ValueRange vr = new sheets.ValueRange.fromJson({"values": data});
        api.spreadsheets.values
            .update(vr, this.spreadSheetID, range,
                valueInputOption: 'USER_ENTERED')
            .then((UpdateValuesResponse r) {
          log("Updated data at $range", name: "SHEET");
          client.close();
        });
      });
    });
  }
}
