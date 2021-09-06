import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import '../model/fluffy_pix_api_extension.dart';
import 'views/hashtag_view.dart';

class HashtagPage extends StatefulWidget {
  final String hashtag;
  const HashtagPage({required this.hashtag, Key? key}) : super(key: key);

  @override
  HashtagPageController createState() => HashtagPageController();
}

class HashtagPageController extends State<HashtagPage> {
  List<Status> timeline = [];
  List<Status> localReplies(String statusId) =>
      timeline.where((status) => status.inReplyToId == statusId).toList();

  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();

  void refresh() async {
    try {
      timeline = await FluffyPix.of(context).requestTagTimeline(widget.hashtag);
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
    final index = timeline
        .indexWhere((s) => s.id == status.id || s.reblog?.id == status.id);
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
      final statuses = await FluffyPix.of(context)
          .requestTagTimeline(widget.hashtag, maxId: timeline.last.id);
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
  Widget build(BuildContext context) => HashtagPageView(this);
}
