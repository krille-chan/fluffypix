import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../home.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;

  const HomePageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.settings),
          onPressed: controller.settingsAction,
        ),
        title: const Text(AppConfigs.applicationName),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.chat_bubble_2),
            onPressed: () {},
          ),
        ],
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: controller.timeline.isNotEmpty,
        onRefresh: controller.refresh,
        onLoading: controller.loadMore,
        child: ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.timeline.length,
          itemBuilder: (context, i) => StatusWidget(
            status: controller.timeline[i],
            onUpdate: controller.onUpdateStatus,
          ),
        ),
      ),
      bottomNavigationBar: DefaultBottomBar(
          currentIndex: 0,
          onCurrentIndexTab: () => controller.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
              )),
    );
  }
}
