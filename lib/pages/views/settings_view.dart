import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
            title: Text(L10n.of(context)!.account),
            onTap: controller.settingsAction,
          ),
          ListTile(
            title: Text(L10n.of(context)!.logout),
            onTap: controller.logout,
          ),
        ],
      ),
      bottomNavigationBar: DefaultBottomBar(
        scrollController: controller.scrollController,
      ),
    );
  }
}
