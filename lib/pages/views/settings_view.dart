import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffypix/utils/custom_about_dialog.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import '../settings.dart';

class SettingsPageView extends StatelessWidget {
  final SettingsPageController controller;

  const SettingsPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.settings),
      ),
      body: ListView(
        controller: controller.scrollController,
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.person),
            title: Text(L10n.of(context)!.account),
            onTap: controller.settingsAction,
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.bell),
            title: Text(L10n.of(context)!.notifications),
            onTap: controller.goToNotificationSettings,
          ),
          const Divider(),
          SwitchListTile(
            value: controller.allowAnimatedAvatars,
            onChanged: controller.setAllowAnimatedAvatars,
            title: Text(L10n.of(context)!.allowAnimatedAvatars),
          ),
          SwitchListTile(
            value: controller.displayThumbnailsOnly,
            onChanged: controller.setDisplayThumbnailsOnly,
            title: Text(L10n.of(context)!.displayThumbnailsOnly),
          ),
          SwitchListTile(
            value: controller.useInAppBrowser,
            onChanged: controller.setUseInAppBrowser,
            title: Text(L10n.of(context)!.openLinksInAppBrowser),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(CupertinoIcons.doc_circle),
            title: Text(L10n.of(context)!.privacy),
            onTap: controller.privacyAction,
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.info_circle),
            title: Text(L10n.of(context)!.about),
            onTap: () => showCustomAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.question_circle),
            title: Text(L10n.of(context)!.help),
            onTap: controller.helpAction,
          ),
          const Divider(),
          ListTile(
            leading: controller.logoutLoading
                ? const CupertinoActivityIndicator()
                : const Icon(CupertinoIcons.delete_right),
            title: Text(L10n.of(context)!.logout),
            onTap: controller.logoutLoading ? null : controller.logout,
          ),
        ],
      ),
      currentIndex: 5,
    );
  }
}
