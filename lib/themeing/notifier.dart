import 'dart:convert';

import 'package:flutter/material.dart';

// final darkTheme = ThemeData(
//   fontFamily: 'OpenSans',
//   primarySwatch: Colors.grey,
//   primaryColor: Colors.black,
//   brightness: Brightness.dark,
//   backgroundColor: const Color(0xFF212121),
//   iconTheme: IconThemeData(color: Colors.black),
//   accentColor: Colors.white,
//   accentIconTheme: IconThemeData(color: Colors.black),
//   dividerColor: Colors.black12,
// );

// final lightTheme = ThemeData(
//     fontFamily: 'OpenSans',
//     primarySwatch: Colors.grey,
//     primaryColor: Color.fromRGBO(63, 99, 247, 1),
//     brightness: Brightness.light,
//     backgroundColor: const Color(0xFFE5E5E5),
//     accentColor: Colors.black,
//     accentIconTheme: IconThemeData(color: Colors.white),
//     iconTheme: IconThemeData(color: Colors.black),
//     dividerColor: Colors.white54,
//     textTheme: TextTheme(headline1: TextStyle(color: Colors.black)));

// class ThemeNotifier with ChangeNotifier {
//   ThemeData _themeData;

//   ThemeNotifier(this._themeData);
//   bool isDark;
//   getTheme() => _themeData;

//   setTheme(isDark) async {
//     if (isDark) {
//       _themeData = darkTheme;
//     } else {
//       _themeData = lightTheme;
//     }

//     notifyListeners();
//   }
// }

class ThemeContainer {
  Color backgroundColor;
  Color appBarColor;
  Color textHeadingColor;
  Color textSubheadingColor;
  Color iconColor;
  Color indicatorColor;
  Color expansionTileHighlight;
  Color accentColor;
  Color floatingColor;
  Color cardAccent;
  Color upvoteColor;
  Color downvoteColor;
  Color iconColorLite;
  Color buttonColor;
  Color buttonContentColor;
  ThemeContainer(
      {this.backgroundColor,
      this.appBarColor,
      this.textHeadingColor,
      this.textSubheadingColor,
      this.iconColor,
      this.indicatorColor,
      this.expansionTileHighlight,
      this.accentColor,
      this.cardAccent,
      this.floatingColor,
      this.downvoteColor,
      this.upvoteColor,
      this.buttonColor,
      this.buttonContentColor,
      this.iconColorLite});
}

ThemeContainer lightTheme = ThemeContainer(
  backgroundColor: Colors.white,
  appBarColor: Colors.transparent,
  textHeadingColor: Colors.black,
  textSubheadingColor: Colors.black.withAlpha(158),
  iconColor: Colors.black,
  indicatorColor: Colors.black,
  expansionTileHighlight: Colors.black,
  floatingColor: Colors.black,
  accentColor: Colors.black,
  upvoteColor: Colors.green,
  downvoteColor: Colors.red,
  iconColorLite: Colors.black.withAlpha(100),
  cardAccent: Colors.black.withAlpha(3),
  buttonColor: Colors.black,
  buttonContentColor: Colors.white,
);
ThemeContainer darkTheme = ThemeContainer(
  backgroundColor: Color.fromRGBO(36, 36, 36, 1),
  appBarColor: Color.fromRGBO(33, 33, 33, 1),
  textHeadingColor: Colors.white.withAlpha(200),
  textSubheadingColor: Colors.white.withAlpha(158),
  iconColor: Colors.white.withAlpha(200),
  iconColorLite: Colors.white.withAlpha(100),
  indicatorColor: Colors.white,
  expansionTileHighlight: Colors.black,
  accentColor: Colors.black,
  floatingColor: Colors.black,
  cardAccent: Colors.white.withAlpha(3),
  upvoteColor: Color.fromRGBO(7, 143, 18, 1),
  downvoteColor: Color.fromRGBO(143, 12, 7, 1),
  buttonColor: Colors.black,
  buttonContentColor: Colors.white,
);

ThemeContainer theme = lightTheme;

void swapTheme(darkOn) {
  if (darkOn) {
    theme = darkTheme;
  } else {
    theme = lightTheme;
  }
}
