import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../messages.dart';

class MessagesPageView extends StatelessWidget {
  final MessagesPageController controller;
  const MessagesPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.messages),
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
            replyMode: true,
          ),
        ),
      ),
      bottomNavigationBar: DefaultBottomBar(
        scrollController: controller.scrollController,
      ),
    );
  }
}
