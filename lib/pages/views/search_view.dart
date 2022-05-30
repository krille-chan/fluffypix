import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:fluffypix/widgets/horizontal_account_list.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import '../search.dart';

class SearchPageView extends StatelessWidget {
  final SearchPageController controller;

  const SearchPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              prefixIcon: controller.loading
                  ? const CupertinoActivityIndicator()
                  : const Icon(CupertinoIcons.search),
              suffixIcon: IconButton(
                icon: const Icon(CupertinoIcons.delete_left),
                onPressed: controller.cancelSearch,
              ),
              hintText: L10n.of(context)!.search,
            ),
          ),
        ),
      ),
      body: controller.searchResult != null
          ? (controller.searchResult!.accounts.isEmpty &&
                  controller.searchResult!.statuses.isEmpty &&
                  controller.searchResult!.hashtags.isEmpty)
              ? Center(child: Text(L10n.of(context)!.suchEmpty))
              : ListView(
                  physics: controller.scrollPhysics,
                  controller: controller.scrollController,
                  children: [
                    if (controller.searchResult!.accounts.isNotEmpty) ...[
                      Material(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            L10n.of(context)!.users,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      HorizontalAccountList(
                        accounts: controller.searchResult!.accounts,
                        onTap: controller.goToUser,
                      ),
                      const Divider(height: 1),
                    ],
                    if (controller.searchResult!.hashtags.isNotEmpty) ...[
                      Material(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            L10n.of(context)!.hashtags,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      SizedBox(
                        height: 56,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.searchResult!.hashtags.length,
                          padding: const EdgeInsets.all(8.0),
                          itemBuilder: (context, i) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Material(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                borderRadius: BorderRadius.circular(64),
                                elevation: 1,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(64),
                                  onTap: () => controller.goToHashtag(controller
                                      .searchResult!.hashtags[i].name),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      '#${controller.searchResult!.hashtags[i].name}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
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
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            L10n.of(context)!.statuses,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
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
          : Column(
              children: [
                Expanded(
                  child: controller.useDiscoverGridView
                      ? SmartRefresher(
                          controller: controller.refreshController,
                          enablePullDown: true,
                          enablePullUp: controller.timeline.isNotEmpty,
                          onRefresh: controller.refresh,
                          onLoading: controller.loadMore,
                          child: controller.timeline.isEmpty
                              ? Center(child: Text(L10n.of(context)!.suchEmpty))
                              : GridView.builder(
                                  controller: controller.scrollController,
                                  itemCount: controller.timeline.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, i) => StatusContent(
                                    status: controller.timeline[i],
                                    imageStatusMode: ImageStatusMode.discover,
                                  ),
                                ),
                        )
                      : SmartRefresher(
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
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 42,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CupertinoSlidingSegmentedControl<bool>(
                        onValueChanged: controller.setUseDiscoverGridView,
                        groupValue: controller.useDiscoverGridView,
                        children: const {
                          false: Icon(Icons.view_day_outlined),
                          true: Icon(CupertinoIcons.square_grid_3x2),
                        },
                      ),
                      CupertinoSlidingSegmentedControl<bool>(
                        onValueChanged: controller.setUsePublicTimeline,
                        groupValue: controller.usePublicTimeline,
                        children: {
                          false: Text(L10n.of(context)!.local),
                          true: Text(L10n.of(context)!.worldWide),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
      currentIndex: 1,
      scrollController: controller.scrollController,
    );
  }
}
