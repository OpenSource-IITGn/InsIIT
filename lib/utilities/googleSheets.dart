import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:shared_preferences/shared_preferences.dart';

final _credentials = new auth.ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "iitgn-instituteapp",
  "private_key_id": "ea292c7a455c0f81c152e86a4fd34f189993f3c3",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCUt5sMLqqlt6A5\nWkIQbhyneKQj0b7kPQNt++iIasf6He3p0ytTDUCEPzZFQHGOFJPWSktkNu7+xyJb\nMn1tuZ6gS4WJhgLBp15qtE7kiaD+Z4brdXckZ1Ptzw+8UbuSg3cbf4k5DGDfxSXr\nALS6HFUNC3ACzPW8qAVB10PT/5wjfjGxV+rMp00sK8nK/HxKj9Mr/nsxIROCCpdk\nAzTBQkkAWCfcU4mUxu/y66zMsKsUH6bvwpvJf+v7si3GKikPmyN5pA36UNy/4YBr\nc8tnri39EwGo0HjS7+iPQm1DII6gx+geqJKUjgWfC4XwKOftamFNXNXXrk2WcBuW\nkllVvkDZAgMBAAECggEAAxcQke97TL+0xNRPCJvdHQ647GSckI4C/vtLwN/lIVmT\nWrcwUIS3OTg+BrDY2zCqxLpc+CtbCnC1UktJh2jitqZzEyE1d/QkFlgCRqXkcjzQ\n9R4G+HrsJ8YUZ9+T4+624BuljImpDqVATTKBztctXjzFWk2LcpzUJSLVrjdCtYsO\n3VLW5AD2XREXqfQnrKc2CfjC7+WSW9X2EtXNhUhNtEgrRBKcSYu6vztvhBxabATV\n81SBVbZkyi+6frhAbUEL24JqtdCphxFyxBXHYLQJCcr8fnbWELze/uF3ZUtBuA3i\nwRybEDN6b0WII4NndvTiTeT9k0hjtoxbwo4V9fOOrQKBgQDIBUE7v1MtxQ2xaBjA\n/Zbvs6KCBLvSc0j8euwnGrCiYcL82JIj9SwbW7NWnLctMt+IjgdhJih2PdUkjEAt\nIhdibtYufqUDgRU35EpbWGaXZGuC86X8RQ+u6ZyBn3G3+4hq3xl8IEoYQmtdWBGs\n7okIuV9rvWg4MZEwYRde72rTvQKBgQC+Vqd+D/DvIUlKVjvsZyv8lHRt+0fVBpzG\nhCksv17BED+fPj6ge6Xd81l4iNN2wpspBOr+0LL3HPAJSG/m3xda23jn2il1MIPX\n0dV1a73ie+L86FUDtSGmZqFnVkuHTQMt6mCSzRWbuchb6GchvJgS08IbtHthZuzd\nyJ08qQ9lTQKBgB5eHd9SVvCWAFQ0970lQys1XLDcwx9afXRHvV7agILG0PHOd7GZ\n4Y5tx7aYqH7mQGXdGmW3g2EgViHsYTn4+Q/qv/3jIG59xJjtwhRIQZsuldwV3deF\nLLJjqW1MpdlHCRkgsh/UTyuLuf08B8L3nDqE2mXjJdWSQPbVZtT1CIUJAoGBAIrW\nMn5lql0Dbq5mkHc0GoW20+aVcCQXGqxDIrWdMcSp0X6arJvrFWX8Z7rgMz9hXERj\nbfZIzQIrfXuH9vf0qth/VoXoQG1W4hS+3nE0EeHuc/f+kGSP7uet3PW/oIAk0Ljh\nSWhLaAObVGaV8wRMyLCS/fevgn/dz9FG0Eq7FpvRAoGAKS1CkmLSz0P5MMnNzrV3\nGy58qfEYJpAvs8lX6xabcTiuaD5dNk4zAgDv6iYuT69+j/TP4ReX9U87AOvwjDAT\nPRUTBIfMnK0IJxgnPzRMch10lRy7YDvmdCJHwFtBLl050AtoSdv7PrgaOEcLw9JL\nvQxYOLNxJdRv5e3Kr2+bgcs=\n-----END PRIVATE KEY-----\n",
  "client_email": "iitgn-institute-app@iitgn-instituteapp.iam.gserviceaccount.com",
  "client_id": "108206908111006360376",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/iitgn-institute-app%40iitgn-instituteapp.iam.gserviceaccount.com"
}


''');

class GSheet {
  final scopes = [sheets.SheetsApi.SpreadsheetsScope];
  String spreadSheetID;
  GSheet(String id) {
    this.spreadSheetID = id;
  }
  Future writeData(var data, String range) async {
    //range is like sheetname!A:J

    await auth
        .clientViaServiceAccount(_credentials, this.scopes)
        .then((client) {
      auth
          .obtainAccessCredentialsViaServiceAccount(
              _credentials, this.scopes, client)
          .then((auth.AccessCredentials cred) {
        SheetsApi api = new SheetsApi(client);
        ValueRange vr = new sheets.ValueRange.fromJson({
          "values": data //data is [[row1],[row2], ...]
        });
        api.spreadsheets.values
            .append(vr, this.spreadSheetID, range, valueInputOption: 'USER_ENTERED')
            .then((AppendValuesResponse r) {
          print("SENT DATA TO SHEETS");
          client.close();
        });
      });
    });
  }

  Future<List> getData(String range) async {
    //range in the form "sheetname!A:C" A:C is range of columns
    var returnval;
    await auth
        .clientViaServiceAccount(_credentials, this.scopes)
        .then((client) async {
      await auth
          .obtainAccessCredentialsViaServiceAccount(
              _credentials, this.scopes, client)
          .then((auth.AccessCredentials cred) async {
        SheetsApi api = new SheetsApi(client);
        await api.spreadsheets.values.get(this.spreadSheetID, range).then((qs) {
          returnval = qs.values;
        });
      });
    });
    //data returned in the form of [[row], [row], [row], [row]]
    return returnval;
  }
}
