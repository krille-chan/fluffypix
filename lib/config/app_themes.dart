import 'package:fluffypix/config/app_configs.dart';
import 'package:flutter/material.dart';

abstract class AppThemes {
  static final ThemeData light = ThemeData.light().copyWith(
    inputDecorationTheme: const InputDecorationTheme(
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
    popupMenuTheme: PopupMenuThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: Colors.black),
    ),
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppConfigs.primaryColor,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
    ),
    primaryColor: AppConfigs.primaryColor,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: AppConfigs.primaryColor,
          secondary: AppConfigs.primaryColor,
          secondaryVariant: AppConfigs.secondaryColor,
        ),
    appBarTheme: const AppBarTheme(
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
    secondaryHeaderColor: const Color(0xffeeeffe),
  );
  static final ThemeData dark = ThemeData.dark().copyWith(
    dividerColor: Colors.grey[800],
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.black,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppConfigs.secondaryColor,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    primaryColor: AppConfigs.secondaryColor,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: AppConfigs.secondaryColor,
          secondary: AppConfigs.secondaryColor,
          secondaryVariant: AppConfigs.primaryColor,
        ),
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          centerTitle: true,
          brightness: Brightness.dark,
          color: Colors.grey[900],
          textTheme: const TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 1,
        ),
    secondaryHeaderColor: const Color(0xff232543),
  );
}
