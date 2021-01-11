import 'dart:io';

import 'package:instiapp/utilities/googleSheets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

String stringReturn(String text) {
  if (text == null) {
    return 'None';
  } else if (text.length < 100) {
    return text;
  } else {
    return text.substring(0, 99);
  }
}

GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
GSheet sheetTL = GSheet('1bl2cxtL44LrmVjgVK3ZA6yVGdXuTU6H77eaLm3OFqK0');

Future<File> localFile(String range) async {
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  String filename = tempPath + range + '.csv';
  return File(filename);
}

Future getCachedData(fileName) async {
  var file = await localFile(fileName);
  bool exists = await file.exists();
  if (exists) {
    await file.open();
    String cache = await file.readAsString();
    List data = [];
    var json = jsonDecode(cache);
    json['key'].forEach((item) {
      data.add(item);
    });
    return data;
  } else {
    return [];
  }
}

Future storeCachedData(fileName, list) async {
  var file = await localFile(fileName);
  bool exists = await file.exists();
  if (exists) {
    await file.delete();
  }
  await file.create();
  await file.open();

  Map<String, dynamic> json = {'key': list};
  await file.writeAsString(jsonEncode(json));
  return true;
}
