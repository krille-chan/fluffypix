import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void linksCallback(String link, BuildContext context) {
  final uri = Uri.parse(link);
  if (uri.pathSegments.length >= 2 &&
      uri.pathSegments[uri.pathSegments.length - 2] == 'tags') {
    Navigator.of(context).pushNamed('/tags/${uri.pathSegments.last}');
    return;
  }
  launch(
    link,
    forceSafariVC: FluffyPix.of(context).useInAppBrowser,
    forceWebView: FluffyPix.of(context).useInAppBrowser,
  );
}
