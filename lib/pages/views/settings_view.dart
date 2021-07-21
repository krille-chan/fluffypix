import 'package:flutter/material.dart';

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
            title: const Text('Logout'),
            onTap: controller.logout,
          ),
        ],
      ),
    );
  }
}
