import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/widgets/horizontal_account_list.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status.dart';
import '../home.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;

  const HomePageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(
        leading: AppThemes.isColumnMode(context)
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
          if (AppThemes.isColumnMode(context))
            IconButton(
              onPressed: controller.refreshController.requestRefresh,
              icon: const Icon(CupertinoIcons.refresh_circled),
            ),
          if (!AppThemes.isColumnMode(context))
            IconButton(
              icon: const Icon(CupertinoIcons.mail),
              onPressed: controller.goToMessages,
            ),
        ],
      ),
      floatingActionButton: controller.seeNewStatuses
          ? Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton.extended(
                onPressed: controller.refreshController.requestRefresh,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).textTheme.bodyText1?.color,
                icon: const Icon(CupertinoIcons.up_arrow),
                label: Text(L10n.of(context)!.seeNewPosts),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
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
                  !AppThemes.isWideColumnMode(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.trendAccounts.isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Text(
                            L10n.of(context)!.discoverUsers,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      HorizontalAccountList(
                        accounts: controller.trendAccounts,
                        onTap: controller.goToUser,
                      ),
                      const Divider(height: 1),
                    ],
                    if (controller.trends.isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
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
                                  horizontal: 4.0,
                                  vertical: 4.0,
                                ),
                                child: Material(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(64),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
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
                    ],
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
