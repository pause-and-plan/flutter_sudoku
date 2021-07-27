import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color(0xFF2EBDF9);
  static const Color primary_light = Color(0xFFB8D4E0);
  static const Color secondary = Color(0xFF3B6B7F);
  static const Color secondary_light = Color(0xFF64828F);
  static const Color background_0 = Color(0xFF172429);
  static const Color background_1 = Color(0xFF0D181D);
}

ThemeData myTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColorDark: Colors.blue,
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
      side: BorderSide(color: Colors.white),
    ),
  ),
);

const double aspectRatio = 1;

const double boxMaxSize = 60;
const double boxSize = 10.7;
