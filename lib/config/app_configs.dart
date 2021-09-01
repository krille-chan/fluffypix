import 'package:flutter/material.dart';

abstract class AppConfigs {
  static const String applicationName = 'FluffyPix';
  static const String applicationWebsite =
      'https://gitlab.com/KrilleFear/fluffypix';
  static const double borderRadius = 12.0;
  static const String hiveBoxName = 'fluffypix_box';
  static const String hiveBoxAccountKey = 'fluffypix_box_account';
  static const String loginRedirectUri = 'fluffypix://login';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const String privacyUrl = '';
  static const Color primaryColor = Color(0xFF5625BA);
  static const Color primaryColorLight = Color(0xFFCCBDEA);
  static const Color secondaryColor = Color(0xFF41a2bc);
  static const String fallbackBlurHash = 'L5H2EC=PM+yV0g-mq.wG9c010J}I';
}
