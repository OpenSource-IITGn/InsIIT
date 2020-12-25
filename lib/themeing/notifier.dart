import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  fontFamily: 'OpenSans',
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  iconTheme: IconThemeData(color: Colors.black),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  fontFamily: 'OpenSans',
  primarySwatch: Colors.grey,
  primaryColor: Color.fromRGBO(63, 99, 247, 1),
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  iconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.white54,
);

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);
  bool isDark;
  getTheme() => _themeData;

  setTheme(isDark) async {
    if (isDark) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }

    notifyListeners();
  }
}
