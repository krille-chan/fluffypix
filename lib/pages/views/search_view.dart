import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
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
            decoration: InputDecoration(
              suffixIcon: const Icon(CupertinoIcons.search),
              hintText: L10n.of(context)!.search,
              filled: true,
              fillColor: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
      ),
      body: SmartRefresher(
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
