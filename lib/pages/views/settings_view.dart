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
        title: const Text('Settings'),
      ),
      body: ListView(
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
    );
  }
}
