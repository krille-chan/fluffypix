import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffypix/config/app_configs.dart';

abstract class AppThemes {
  static const double radius = 12;
  static final ThemeData light = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
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
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      brightness: Brightness.light,
      color: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 1,
    ),
    secondaryHeaderColor: const Color(0xffeeeffe),
  );
  static final ThemeData dark = ThemeData.dark().copyWith(
    dividerColor: Colors.grey[800],
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.black,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
          color: Colors.grey[900],
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 1,
        ),
    secondaryHeaderColor: const Color(0xff232543),
  );

  static const double columnWidth = 300;
  static const double mainColumnWidth = columnWidth * 2;

  static bool isColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width >= columnWidth * 3 + 3;

  static bool isWideColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width >= columnWidth * 4 + 3;
}
