import 'dart:async';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'views/search_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  SearchPageController createState() => SearchPageController();
}

class SearchPageController extends State<SearchPage> {
  List<Status> timeline = [];
  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();

  void refresh() async {
    try {
      timeline = await FluffyPix.of(context).requestPublicTimeline();
      setState(() {});
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
      if (timeline.isEmpty) {
        Timer(const Duration(seconds: 3), refreshController.requestRefresh);
      }
      rethrow;
    }
  }

  void loadMore() async {
    try {
      final statuses = await FluffyPix.of(context)
          .requestPublicTimeline(maxId: timeline.last.id);
      timeline.addAll(statuses);
      setState(() {});
      refreshController.loadComplete();
    } catch (_) {
      refreshController.loadFailed();
      rethrow;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SearchPageView(this);
}
