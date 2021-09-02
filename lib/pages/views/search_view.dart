import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../search.dart';

class SearchPageView extends StatelessWidget {
  final SearchPageController controller;

  const SearchPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.all(8.0),
          height: 56,
          child: TextField(
            controller: controller.textEditingController,
            onChanged: controller.searchQueryWithCooldown,
            onSubmitted: controller.searchQuery,
            decoration: InputDecoration(
              suffixIcon: controller.loading
                  ? const CupertinoActivityIndicator()
                  : const Icon(CupertinoIcons.search),
              hintText: L10n.of(context)!.search,
              filled: true,
              fillColor: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
      ),
      body: controller.searchResult != null
          ? ListView(
              physics: controller.scrollPhysics,
              controller: controller.scrollController,
              children: [
                if (controller.searchResult!.accounts.isNotEmpty) ...[
                  Material(
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        L10n.of(context)!.users,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: 94,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.searchResult!.hashtags.length,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => controller.goToUser(
                              controller.searchResult!.accounts[i].id),
                          child: SizedBox(
                            width: 94,
                            height: 94,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(64),
                                  elevation: 2,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      controller
                                          .searchResult!.accounts[i].avatar,
                                    ),
                                    radius: 32,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller
                                      .searchResult!.accounts[i].displayName,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (controller.searchResult!.hashtags.isNotEmpty) ...[
                  Material(
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        L10n.of(context)!.hashtags,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: 56,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.searchResult!.hashtags.length,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(64),
                          onTap: () => controller.goToHashtag(
                              controller.searchResult!.hashtags[i].name),
                          child: Chip(
                            backgroundColor:
                                Theme.of(context).appBarTheme.backgroundColor,
                            elevation: 3,
                            label: Text(
                              '#${controller.searchResult!.hashtags[i].name}',
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
                  ),
                  const Divider(height: 1),
                ],
                if (controller.searchResult!.statuses.isNotEmpty) ...[
                  Material(
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        L10n.of(context)!.statuses,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(
                        parent: controller.scrollPhysics),
                    itemCount: controller.searchResult!.statuses.length,
                    itemBuilder: (context, i) => StatusWidget(
                      status: controller.searchResult!.statuses[i],
                      onUpdate: controller.onUpdateStatus,
                    ),
                  ),
                ],
              ],
            )
          : SmartRefresher(
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: controller.timeline.isNotEmpty,
              onRefresh: controller.refresh,
              onLoading: controller.loadMore,
              child: GridView.builder(
                controller: controller.scrollController,
                itemCount: controller.timeline.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, i) => StatusContent(
                  status: controller.timeline[i],
                  imageStatusMode: ImageStatusMode.discover,
                ),
              ),
            ),
      bottomNavigationBar: DefaultBottomBar(
        currentIndex: 1,
        scrollController: controller.scrollController,
      ),
    );
  }
}
