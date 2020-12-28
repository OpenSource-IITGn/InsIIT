import 'package:flutter/material.dart';

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
      this.bottomNavyBarColor,
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
  bottomNavyBarColor: Colors.white,
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
  bottomNavyBarColor: Color.fromRGBO(48, 48, 48, 1),
);

ThemeContainer theme = lightTheme;

void swapTheme(darkOn) {
  if (darkOn) {
    theme = darkTheme;
  } else {
    theme = lightTheme;
  }
}
