import 'package:instiapp/utilities/googleSheets.dart';

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
GSheet roomSheet = GSheet('1ubVLWH6bY4xcS9xXGTPxUbpcy96ZbQLhyonL3TY7tXs');