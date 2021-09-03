import 'dart:async';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'views/messages_view.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  MessagesPageController createState() => MessagesPageController();
}

class MessagesPageController extends State<MessagesPage> {
  List<Status> timeline = [];

  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();

  void refresh() async {
    try {
      timeline = (await FluffyPix.of(context).requestConversations())
          .map((c) => c.lastStatus)
          .where((s) => s != null)
          .map((c) => c!)
          .toList();

      FluffyPix.of(context)
          .storeCachedTimeline<Status>('messages', timeline, (t) => t.toJson());
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

  void onUpdateStatus(Status? status, [String? deleteId]) {
    if (status == null) {
      setState(() {
        timeline.removeWhere((s) => s.id == deleteId);
      });
      return;
    }
    final index = timeline.indexWhere((s) => s.id == status.id);
    if (index == -1) {
      refreshController.requestRefresh();
    } else {
      setState(() {
        timeline[index] = status;
      });
    }
  }

  void loadMore() async {
    try {
      final statuses = (await FluffyPix.of(context)
              .requestConversations(maxId: timeline.last.id))
          .map((c) => c.lastStatus)
          .where((s) => s != null)
          .map((c) => c!)
          .toList();
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
    timeline = FluffyPix.of(context)
            .getCachedTimeline<Status>('messages', (j) => Status.fromJson(j)) ??
        [];
  }

  @override
  Widget build(BuildContext context) => MessagesPageView(this);
}
