import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../home.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;

  const HomePageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(
        leading: controller.columnMode
            ? IconButton(
                icon: const Icon(CupertinoIcons.home),
                onPressed: controller.scrollTop,
              )
            : IconButton(
                icon: const Icon(CupertinoIcons.settings),
                onPressed: controller.settingsAction,
              ),
        title: const Text(AppConfigs.applicationName),
        actions: [
          if (controller.columnMode)
            IconButton(
              onPressed: controller.refreshController.requestRefresh,
              icon: const Icon(CupertinoIcons.refresh_circled),
            ),
          if (!controller.columnMode)
            IconButton(
              icon: const Icon(CupertinoIcons.mail),
              onPressed: controller.goToMessages,
            ),
        ],
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: controller.filteredTimeline.isNotEmpty,
        onRefresh: controller.refresh,
        onLoading: controller.loadMore,
        child: ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.filteredTimeline.length,
          itemBuilder: (context, i) => i == 1 &&
                  !controller.wideColumnMode &&
                  controller.trends.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          L10n.of(context)!.trendingHashtags,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (final hashtag in controller.trends)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Material(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                borderRadius: BorderRadius.circular(64),
                                elevation: 2,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(64),
                                  onTap: () =>
                                      controller.goToHashtag(hashtag.name),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      '#${hashtag.name}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    StatusWidget(
                      status: controller.filteredTimeline[i],
                      onUpdate: controller.onUpdateStatus,
                      replies: controller
                          .localReplies(controller.filteredTimeline[i].id),
                    ),
                  ],
                )
              : StatusWidget(
                  status: controller.filteredTimeline[i],
                  onUpdate: controller.onUpdateStatus,
                  replies: controller
                      .localReplies(controller.filteredTimeline[i].id),
                ),
        ),
      ),
      currentIndex: 0,
      scrollController: controller.scrollController,
    );
  }
}
