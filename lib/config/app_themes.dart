import 'package:flutter/material.dart';

import 'package:fluffypix/config/app_configs.dart';

abstract class AppThemes {
  static const double radius = 12;

  static ThemeData get light => ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: AppConfigs.primaryColor,
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          filled: true,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        dividerColor: Colors.grey.shade100,
      );

  static ThemeData get dark => ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppConfigs.primaryColor,
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          filled: true,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        dividerColor: Colors.grey.shade700,
      );

  static const double columnWidth = 300;
  static const double mainColumnWidth = columnWidth * 2;

  static bool isColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width >= columnWidth * 3 + 3;

  static bool isWideColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width >= columnWidth * 4 + 3;
}
