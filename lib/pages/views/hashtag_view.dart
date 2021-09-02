import 'package:fluffypix/pages/hashtag.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HashtagPageView extends StatelessWidget {
  final HashtagPageController controller;
  const HashtagPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#${controller.widget.hashtag}'),
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
    );
  }
}
