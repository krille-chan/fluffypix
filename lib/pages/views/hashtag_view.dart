import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:fluffypix/pages/hashtag.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status.dart';

class HashtagPageView extends StatelessWidget {
  final HashtagPageController controller;
  const HashtagPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(
        title: Text('#${controller.widget.hashtag}'),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: controller.timeline.isNotEmpty,
        onRefresh: controller.refresh,
        onLoading: controller.loadMore,
        child: controller.timeline.isEmpty
            ? Center(child: Text(L10n.of(context)!.suchEmpty))
            : ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.timeline.length,
                itemBuilder: (context, i) => StatusWidget(
                  status: controller.timeline[i],
                  onUpdate: controller.onUpdateStatus,
                ),
              ),
      ),
      scrollController: controller.scrollController,
    );
  }
}
