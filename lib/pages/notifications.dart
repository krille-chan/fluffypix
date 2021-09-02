import 'dart:async';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'views/notifications_view.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  NotificationsPageController createState() => NotificationsPageController();
}

class NotificationsPageController extends State<NotificationsPage> {
  List<PushNotification> timeline = [];
  String? next;

  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();

  void refresh() async {
    try {
      final chunk = await FluffyPix.of(context).getNotifications();
      timeline = chunk.chunk;
      next = chunk.next;
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
      final chunk = await FluffyPix.of(context).getNotifications(maxId: next);
      next = chunk.next;
      timeline.addAll(chunk.chunk);
      setState(() {});
      refreshController.loadComplete();
    } catch (_) {
      refreshController.loadFailed();
      rethrow;
    }
  }

  void goToProfile(String id) => Navigator.of(context).pushNamed('/user/$id');
  void goToStatus(String id) => Navigator.of(context).pushNamed('/status/$id');

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NotificationsPageView(this);
}
