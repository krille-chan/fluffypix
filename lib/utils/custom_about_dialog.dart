import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffypix/config/app_configs.dart';

void showCustomAboutDialog(BuildContext context) async {
  var version = L10n.of(context)!.unknown;
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  } catch (_) {}
  showAboutDialog(
    context: context,
    applicationName: AppConfigs.applicationName,
    applicationVersion: version,
    applicationIcon: Image.asset(
      'assets/images/logo.png',
      width: 56,
      height: 56,
    ),
    children: [
      OutlinedButton(
        onPressed: () => launch(AppConfigs.privacyUrl),
        child: Text(L10n.of(context)!.privacy),
      ),
      SizedBox(height: 2),
      OutlinedButton(
        onPressed: () => launch(AppConfigs.applicationWebsite),
        child: Text(L10n.of(context)!.website),
      ),
    ],
  );
}
