import 'dart:async';
import 'dart:io';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/pages/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
  List<Status> get filteredTimeline =>
      timeline.where((status) => status.inReplyToId == null).toList();
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

  void settingsAction() => Navigator.of(context).pushNamed('/settings');

  void goToMessages() => Navigator.of(context).pushNamed('/messages');

  StreamSubscription? _intentTextStreamSubscription;
  StreamSubscription? _intentFileStreamSubscription;

  void _initReceiveSharingIntent() {
    // For sharing images coming from outside the app while the app is in the memory
    _intentFileStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      if (value.isEmpty) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/sharemedia', (r) => r.isFirst,
          arguments: value);
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isEmpty) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/sharemedia', (r) => r.isFirst,
          arguments: value);
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentTextStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value.isEmpty) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/sharetext', (r) => r.isFirst,
          arguments: value);
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value?.isEmpty ?? true) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/sharetext', (r) => r.isFirst,
          arguments: value);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      _initReceiveSharingIntent();
    }
    super.initState();
  }

  @override
  void dispose() {
    _intentTextStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomePageView(this);
  }
}
