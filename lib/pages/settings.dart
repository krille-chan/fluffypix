import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'login.dart';
import 'views/settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageController createState() => SettingsPageController();
}

class SettingsPageController extends State<SettingsPage> {
  final ScrollController scrollController = ScrollController();
  void settingsAction() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      ChromeSafariBrowser().open(
        url: FluffyPix.of(context).instance!.resolveUri(Uri(path: '/settings')),
      );
      return;
    }
    launch(
      FluffyPix.of(context)
          .instance!
          .resolveUri(Uri(path: '/settings'))
          .toString(),
      forceSafariVC: true,
      forceWebView: true,
    );
  }

  void logout() async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context)!.logout,
          message: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.logout,
          cancelLabel: L10n.of(context)!.cancel,
          fullyCapitalizedForMaterial: false,
          isDestructiveAction: true,
        ) !=
        OkCancelResult.ok) {
      return;
    }
    await FluffyPix.of(context).logout();
    await Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => const LoginPage()),
        (route) => false);
  }

  void aboutAction() async {
    final packageInfo = await PackageInfo.fromPlatform();
    showAboutDialog(
      context: context,
      applicationName: AppConfigs.applicationName,
      applicationVersion: packageInfo.version,
      applicationIcon: Image.asset(
        'assets/images/logo.png',
        width: 56,
        height: 56,
      ),
      children: [
        OutlinedButton(
          onPressed: () => launch(AppConfigs.applicationWebsite),
          child: Text(L10n.of(context)!.website),
        ),
      ],
    );
  }

  void helpAction() => launch(AppConfigs.issueUrl);
  void privacyAction() => launch(AppConfigs.privacyUrl);

  bool get allowAnimatedAvatars => FluffyPix.of(context).allowAnimatedAvatars;
  void setAllowAnimatedAvatars(bool b) => setState(() {
        FluffyPix.of(context).allowAnimatedAvatars = b;
      });

  bool get displayThumbnailsOnly => FluffyPix.of(context).displayThumbnailsOnly;
  void setDisplayThumbnailsOnly(bool b) => setState(() {
        FluffyPix.of(context).displayThumbnailsOnly = b;
      });

  bool get useInAppBrowser => FluffyPix.of(context).useInAppBrowser;
  void setUseInAppBrowser(bool b) => setState(() {
        FluffyPix.of(context).useInAppBrowser = b;
      });

  @override
  Widget build(BuildContext context) => SettingsPageView(this);
}
