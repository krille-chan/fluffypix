import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';
import 'views/settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageController createState() => SettingsPageController();
}

class SettingsPageController extends State<SettingsPage> {
  void settingsAction() => launch(
        FluffyPix.of(context)
            .instance!
            .resolveUri(Uri(path: '/settings'))
            .toString(),
        forceSafariVC: true,
        forceWebView: true,
      );
  void logout() async {
    await FluffyPix.of(context).logout();
    await Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => const LoginPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) => SettingsPageView(this);
}
