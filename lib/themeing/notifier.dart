import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Color bottomNavyBarColor;
  Color bottomNavyBarIndicatorColor;
  Color flatButtonOutlineColor;
  Color cardBgColor;
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
      this.cardBgColor,
      this.flatButtonOutlineColor,
      this.upvoteColor,
      this.buttonColor,
      this.buttonContentColor,
      this.bottomNavyBarColor,
      this.bottomNavyBarIndicatorColor,
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
  cardBgColor: Colors.white,
  flatButtonOutlineColor: Colors.black.withAlpha(30),
  buttonColor: Colors.black,
  buttonContentColor: Colors.white,
  bottomNavyBarColor: Colors.white,
  bottomNavyBarIndicatorColor: Colors.black.withAlpha(50),
);
ThemeContainer darkTheme = ThemeContainer(
  backgroundColor: Color.fromRGBO(36, 36, 36, 1),
  appBarColor: Color.fromRGBO(33, 33, 33, 1),
  textHeadingColor: Colors.white.withAlpha(200),
  textSubheadingColor: Colors.white.withAlpha(158),
  iconColor: Colors.white.withAlpha(200),
  flatButtonOutlineColor: Colors.white.withAlpha(30),
  iconColorLite: Colors.white.withAlpha(100),
  indicatorColor: Colors.white,
  expansionTileHighlight: Colors.black,
  accentColor: Colors.black,
  floatingColor: Colors.black,
  cardAccent: Colors.white.withAlpha(3),
  cardBgColor: Colors.white.withAlpha(3),
  upvoteColor: Color.fromRGBO(7, 143, 18, 1),
  downvoteColor: Color.fromRGBO(143, 12, 7, 1),
  buttonColor: Colors.black,
  buttonContentColor: Colors.white,
  bottomNavyBarColor: Color.fromRGBO(48, 48, 48, 1),
  bottomNavyBarIndicatorColor: Colors.black.withAlpha(100),
);

ThemeContainer theme = lightTheme;

Future getTheme() async {
  SharedPreferences s = await SharedPreferences.getInstance();
  var darkOn = s.getBool("dark");
  if (darkOn != null) {
    if (darkOn == true) {
      darkMode = true;
      theme = darkTheme;
    } else {
      darkMode = false;
      theme = lightTheme;
    }
  }
}

void swapTheme(darkOn) {
  if (darkOn) {
    theme = darkTheme;
  } else {
    theme = lightTheme;
  }
  storeThemeInPref(darkOn);
}

void storeThemeInPref(darkOn) async {
  SharedPreferences s = await SharedPreferences.getInstance();
  s.setBool("dark", darkOn);
}
