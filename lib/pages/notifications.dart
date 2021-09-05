import 'dart:async';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/fluffy_pix_api_extension.dart';
import '../model/fluffy_pix_notification_count_extension.dart';

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
      FluffyPix.of(context).storeCachedTimeline<PushNotification>(
          'notifications', chunk.chunk, (t) => t.toJson());
      timeline = chunk.chunk;
      next = chunk.next;
      setState(() {});
      await FluffyPix.of(context).markNotificationsAsRead();
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
    timeline = FluffyPix.of(context).getCachedTimeline<PushNotification>(
            'notifications', (j) => PushNotification.fromJson(j)) ??
        [];
  }

  @override
  Widget build(BuildContext context) => NotificationsPageView(this);
}
