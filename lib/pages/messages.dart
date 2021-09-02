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
  List<Status> localReplies(String statusId) =>
      timeline.where((status) => status.inReplyToId == statusId).toList();

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

  void onUpdateStatus(Status? status, [String? deleteId]) {
    if (status == null) {
      setState(() {
        timeline.removeWhere((s) => s.id == deleteId);
      });
      return;
    }
    setState(() {
      timeline[timeline.indexWhere((s) => s.id == status.id)] = status;
    });
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

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MessagesPageView(this);
}
