import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffypix/model/fluffy_pix.dart';

void linksCallback(String link, BuildContext context) {
  final uri = Uri.parse(link);
  if (uri.pathSegments.length >= 2 &&
      {'tag', 'tags'}.contains(uri.pathSegments[uri.pathSegments.length - 2])) {
    Navigator.of(context).pushNamed('/tags/${uri.pathSegments.last}');
    return;
  }
  launchUrlString(
    link,
    mode: FluffyPix.of(context).useInAppBrowser
        ? LaunchMode.inAppWebView
        : LaunchMode.externalApplication,
  );
}
