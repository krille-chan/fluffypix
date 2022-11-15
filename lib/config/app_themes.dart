import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffypix/config/app_configs.dart';

abstract class AppThemes {
  static const double radius = 12;

  static ThemeData buildTheme(
    ColorScheme? scheme,
    Color? primaryColor,
    bool isLight,
  ) =>
      ThemeData(
        brightness: isLight ? Brightness.light : Brightness.dark,
        useMaterial3: true,
        colorScheme: primaryColor != null ? null : scheme,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isLight ? Brightness.dark : Brightness.light,
            statusBarBrightness: !isLight ? Brightness.dark : Brightness.light,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(),
          filled: true,
        ),
        dividerColor: isLight ? Colors.grey.shade200 : Colors.grey.shade700,
        colorSchemeSeed:
            primaryColor ?? (scheme == null ? AppConfigs.primaryColor : null),
      );

  static const double columnWidth = 300;
  static const double mainColumnWidth = columnWidth * 2;

  static bool isColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width >= columnWidth * 3 + 3;

  static bool isWideColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width >= columnWidth * 4 + 3;
}
