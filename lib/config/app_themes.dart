import 'package:fluffypix/config/app_configs.dart';
import 'package:flutter/material.dart';

abstract class AppThemes {
  static final ThemeData light = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    backgroundColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppConfigs.primaryColor,
      unselectedItemColor: Colors.black,
    ),
    primaryColor: AppConfigs.primaryColor,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: AppConfigs.primaryColor,
          secondary: AppConfigs.primaryColor,
          secondaryVariant: AppConfigs.secondaryColor,
        ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      brightness: Brightness.light,
      color: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 1,
    ),
  );
  static final ThemeData dark = ThemeData.dark();
}
