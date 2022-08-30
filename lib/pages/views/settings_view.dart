import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/utils/custom_about_dialog.dart';
import 'package:fluffypix/utils/theme_mode_localization.dart';
import 'package:fluffypix/widgets/theme_builder.dart';
import '../settings.dart';

class SettingsPageView extends StatelessWidget {
  final SettingsPageController controller;

  const SettingsPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.settings),
      ),
      body: ListView(
        controller: controller.scrollController,
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.paintbrush),
            title: Text(L10n.of(context)!.style),
            trailing: Text(ThemeController.of(context)
                .themeMode
                .toLocalizedString(context)),
            onTap: controller.setThemeMode,
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.color_filter),
            title: Text(L10n.of(context)!.color),
            trailing: Icon(
              Icons.circle,
              color: ThemeController.of(context).primaryColor ??
                  AppConfigs.primaryColor,
            ),
            onTap: controller.setColor,
          ),
          const Divider(),
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
          SwitchListTile.adaptive(
            value: controller.allowAnimatedAvatars,
            onChanged: controller.setAllowAnimatedAvatars,
            title: Text(L10n.of(context)!.allowAnimatedAvatars),
          ),
          SwitchListTile.adaptive(
            value: controller.displayThumbnailsOnly,
            onChanged: controller.setDisplayThumbnailsOnly,
            title: Text(L10n.of(context)!.displayThumbnailsOnly),
          ),
          SwitchListTile.adaptive(
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
    );
  }
}
