import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_login_extension.dart';
import 'package:fluffypix/utils/theme_mode_localization.dart';
import '../widgets/theme_builder.dart';
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

  void helpAction() => launchUrlString(
        AppConfigs.issueUrl,
        mode: FluffyPix.of(context).useInAppBrowser
            ? LaunchMode.inAppWebView
            : LaunchMode.externalApplication,
      );
  void privacyAction() => launchUrlString(
        AppConfigs.privacyUrl,
        mode: FluffyPix.of(context).useInAppBrowser
            ? LaunchMode.inAppWebView
            : LaunchMode.externalApplication,
      );

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

  void setThemeMode() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.style),
        content: StatefulBuilder(builder: (context, setState) {
          final groupValue = ThemeController.of(context).themeMode;
          // ignore: prefer_function_declarations_over_variables
          final onChanged = (val) {
            setState(() {
              ThemeController.of(context).setThemeMode(val);
            });
          };
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: ThemeMode.system,
                groupValue: groupValue,
                onChanged: onChanged,
                title: Text(ThemeMode.system.toLocalizedString(context)),
              ),
              RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: ThemeMode.light,
                groupValue: groupValue,
                onChanged: onChanged,
                title: Text(ThemeMode.light.toLocalizedString(context)),
              ),
              RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: ThemeMode.dark,
                groupValue: groupValue,
                onChanged: onChanged,
                title: Text(ThemeMode.dark.toLocalizedString(context)),
              ),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(L10n.of(context)!.close),
          ),
        ],
      ),
    );
    setState(() {});
  }

  void setColor() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.color),
        content: StatefulBuilder(builder: (context, setState) {
          final groupValue = ThemeController.of(context).primaryColor;
          // ignore: prefer_function_declarations_over_variables
          final onChanged = (val) {
            setState(() {
              ThemeController.of(context).setPrimaryColor(val);
            });
          };
          const colors = [
            null,
            AppConfigs.primaryColor,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.red,
            Colors.pink,
            Colors.teal,
          ];
          return SizedBox(
            height: 360,
            width: 360,
            child: ListView(
              children: colors
                  .map((color) => RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        value: color,
                        groupValue: groupValue,
                        onChanged: onChanged,
                        title: color == null
                            ? Text(L10n.of(context)!.system)
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.circle, color: color),
                              ),
                      ))
                  .toList(),
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(L10n.of(context)!.close),
          ),
        ],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SettingsPageView(this);
}
