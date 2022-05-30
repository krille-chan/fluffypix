import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_login_extension.dart';
import 'login.dart';
import 'views/settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  SettingsPageController createState() => SettingsPageController();
}

class SettingsPageController extends State<SettingsPage> {
  final ScrollController scrollController = ScrollController();
  bool logoutLoading = false;
  void settingsAction() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      ChromeSafariBrowser().open(
        url: FluffyPix.of(context).instance!.resolveUri(Uri(path: '/settings')),
      );
      return;
    }
    launchUrl(
      FluffyPix.of(context).instance!.resolveUri(Uri(path: '/settings')),
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
    setState(() {
      logoutLoading = true;
    });
    try {
      await FluffyPix.of(context).logout();
    } finally {
      setState(() {
        logoutLoading = false;
      });
      await Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => const LoginPage()),
          (route) => false);
    }
  }

  void helpAction() => launchUrlString(AppConfigs.issueUrl);
  void privacyAction() => launchUrlString(AppConfigs.privacyUrl);

  void goToNotificationSettings() =>
      Navigator.of(context).pushNamed('/settings/notifications');

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
