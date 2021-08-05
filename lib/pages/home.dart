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

  void refresh() async {
    print('Refresh timeline');
    try {
      timeline = await FluffyPix.of(context).requestHomeTimeline();
      setState(() {});
      refreshController.refreshCompleted();
    } catch (e, s) {
      refreshController.refreshFailed();
      if (timeline.isEmpty) {
        print('Failed to refresh. Try again in 3 seconds...');
        print(e);
        print(s);
        Timer(const Duration(seconds: 3), refreshController.requestRefresh);
      }
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
