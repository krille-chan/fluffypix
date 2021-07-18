import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;

  const HomePageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: controller.settingsAction,
        ),
        centerTitle: true,
        title: Text(AppConfigs.applicationName),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_outlined),
            onPressed: () => null,
          ),
        ],
      ),
      body: FutureBuilder<List<Status>>(
        future: controller.timelineRequest,
        builder: (context, snapshot) {
          final statuses = snapshot.data;
          if (statuses == null) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: statuses.length,
            itemBuilder: (context, i) => StatusWidget(status: statuses[i]),
          );
        },
      ),
      bottomNavigationBar: DefaultBottomBar(currentIndex: 0),
    );
  }
}
