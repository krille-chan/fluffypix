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
  static const String privacyUrl = '$applicationWebsite/-/blob/main/PRIVACY.md';
  static const String issueUrl = '$applicationWebsite/issues';
  static const Color primaryColor = Color.fromARGB(255, 135, 103, 172);
  static const String fallbackBlurHash = 'L5H2EC=PM+yV0g-mq.wG9c010J}I';
  static const String pushGatewayUrl = 'https://janian.de/push/notify';
  static const List<MobileApp> mobileApps = [
    MobileApp(
      'https://play.google.com/store/apps/details?id=io.fluffypix.app',
      'assets/images/google-play-badge.png',
    ),
    MobileApp(
      'https://gitlab.com/krillefear/fluffypix/-/jobs/artifacts/main/browse?job=build_apk',
      'assets/images/android-download-button.png',
    ),
    MobileApp(
      'https://testflight.apple.com/join/SuyYaKTn',
      'assets/images/appstore-badge.png',
    ),
  ];
}

class MobileApp {
  final String? link;
  final String asset;

  const MobileApp(this.link, this.asset);
}
