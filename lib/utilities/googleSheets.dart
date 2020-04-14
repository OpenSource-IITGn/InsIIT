


import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:shared_preferences/shared_preferences.dart';

String spreadSheetID = '<ENTER SPREADSHEET ID HERE>';

final _credentials = new auth.ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "amlorganizer",
  "private_key_id": "54a717f89e3f8cb38037e457ff6a901bf51ee645",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCaOY0O4bRvz40E\nJXC5m3tiAJTvEUDHCtX0YNLIaeKE6/1I9DXlVwYKVZIcEI+yXQK0Rt6IWvQRex4d\no+mLEWAc3WeXI8uIwnfNAJtdo34WCsPjLfc2C7Cb1GRrtUsVH216qy2yzj115oJN\nUZuEfcvJe7SVNOIBCYqzESaS+MxyEAs+aRrpTg7c+RhUPEM0Dgc3JbrxVf0WUfh3\n2rQtWVrmddQoZlCYsC6fjuMaRLXILJm2u3RcdznFHhPn330QyzkSJwmThlDfTooE\n9IC5BXO3B/wkRhiWOiQpFrPntLUrfFIjOQD6vk5Dm2HU4sMvA6aNm9wuj7N8PVTJ\nFawGxKALAgMBAAECggEAGUGYgJnkzzS5nra07ahxPbzjpvz300DKhgE/M5PnhSYS\nbhqUIvEr65BU46Swq6CAu14pvkHK23wClA8ORXh8eW2ms8EoaUaTkO5rAxwtn1V2\n++LAq8ihTPus0Fi5qYVii+axjqkotoCf0SKuqbViJKZODetBobLa1HVYEFSPQpRt\n8bLRTDv+y/kK1lYRSeUoUoPx5rKTAO9DTLhVEyZV3UGzp0yYug+56trVi8uF9dHI\nGjEid5ZRu0d0vce/vu1/jRk43Tii3q4DPbSBmIUMfa+MWkvd7CD8FvBfacWXG2QV\nQPskniVcK6Jd8eO+dwk4efWICGQ+VUX8bSpgIWiq7QKBgQDLgP3hfCEOXvvv5TNP\nqvv1OMfBv1t3H5FtJqIglzwFgQUvzmguM8Az3MdZToLK1p0G/7MlPkkMazLYI85b\nPyO2e9Qp5MOpjtGplNa7LEIgG/T0KRoG5MCSWXtMmXcHKRKwvrjOzEhvNoZW5vTW\n9Q97rnvLYjT7Mk4r1njNIXnmtQKBgQDCAkN/YqxvRvPS+NvOk5EtNJ0mRgoVGq4T\nmb4DjUFjAId7scbkA/cNaWvBT2lJYWmmJ9aq6PhMTEI5XPCMb8rfUxOCfb4t0xvD\nEepu7YfBBlnuwrIIdlukG51mFe+1NqI912n8merx9F6sohva0bBXfvBQAo2g11Nu\nqnBg0KPjvwKBgD6Zr39tb727+kQRfXdEYb1NeiVfeANs8o9hEv5zh0MqLS5HkESm\nJrnNcIVIYXOEEUnV3oXWYyIu17UlTpVDFvlLnjhE5uuBw30nC+cH9k9qSi/RdPAp\n7hMW85bcnoDVYap9ANycequ7Whfhc++r8tdZFTu7OhELqIBTuVVgtt8BAoGBAJ62\nl11o7cQC+YkISVnP4x5mQoGDHtBxCSPDzGy/bFR/pFaO8zSqAbwZGCwGuQ1tAa8K\nPFWJTUetwyeGXsuk0QStw/ImyCRY5gdJas3gyAQjHAN1h4vgt8ujQ7q2C2nmDggl\nZ/FcQZY64hC8daknjemmURZDYHXKcdjA2jp5tPmlAoGAHRcWWSnZfi9oOOnn8z5s\nToY9V/FYwKuIxPdwUjFzcPq5LjerK0VhCeWaMZMbKrofAY6z3NNq/hHmKz3yb3n2\n+8HdAcbGvb8TJwIruqYt3IQVaSiwVf87FVnx3mDQUTgXLWI4OuFQO3muXXvJrywz\n3Z+aNwEIqcs3F+ppB6zxRzM=\n-----END PRIVATE KEY-----\n",
  "client_email": "<CREATE A NEW SERVICE ACCOUNT FOR THIS. CHECK GOOGLE ON HOW TO MAKE A SERVICE ACCOUNT. Give the spreadsheet access to the service account>",
  "client_id": "116939303152142152816",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/amlorganizeraccnt%40amlorganizer.iam.gserviceaccount.com"
}

''');

final scopes = [sheets.SheetsApi.SpreadsheetsScope];


Future writeData(var data, String range) async { //range is like sheetname!A:J

  await auth.clientViaServiceAccount(_credentials, scopes).then((client) {
    auth
        .obtainAccessCredentialsViaServiceAccount(_credentials, scopes, client)
        .then((auth.AccessCredentials cred) {
      SheetsApi api = new SheetsApi(client);
      ValueRange vr = new sheets.ValueRange.fromJson({
        "values": data //data is [[row1],[row2], ...]
      });
      api.spreadsheets.values
          .append(vr, spreadSheetID, range,
              valueInputOption: 'USER_ENTERED')
          .then((AppendValuesResponse r) {
            print("SENT DATA TO SHEETS");
        client.close();
      });
    });
  });
}

Future<List> getData(String range) async { //range in the form "sheetname!A:C" A:C is range of columns
  var returnval;
  await auth.clientViaServiceAccount(_credentials, scopes).then((client) async {
    await auth
        .obtainAccessCredentialsViaServiceAccount(_credentials, scopes, client)
        .then((auth.AccessCredentials cred) async {
      SheetsApi api = new SheetsApi(client);
      await api.spreadsheets.values.get(spreadSheetID, range).then((qs) {
        returnval = qs.values;
      });
    });
  });
   //data returned in the form of [[row], [row], [row], [row]]
  return returnval;
}

