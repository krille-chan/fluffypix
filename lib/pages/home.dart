import 'dart:async';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/pages/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageController createState() => HomePageController();
}

enum HomePagePopupMenuButtonAction {
  settings,
  logout,
}

class HomePageController extends State<HomePage> {
  List<Status> timeline = [];
  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();

  void refresh() async {
    try {
      timeline = await FluffyPix.of(context).requestHomeTimeline();
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
          .requestHomeTimeline(maxId: timeline.last.id);
      timeline.addAll(statuses);
      setState(() {});
      refreshController.loadComplete();
    } catch (_) {
      refreshController.loadFailed();
      rethrow;
    }
  }

  void settingsAction() => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => const SettingsPage(),
        ),
      );

  void newStatusAction() {}

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomePageView(this);
  }
}
