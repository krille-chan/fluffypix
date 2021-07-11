import 'package:flutter/material.dart';

abstract class AppThemes {
  static final ThemeData light = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      brightness: Brightness.dark,
      titleTextStyle: TextStyle(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 1,
    ),
  );
  static final ThemeData dark = ThemeData.dark();
}
