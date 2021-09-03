import 'dart:async';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/search_result.dart';
import 'package:fluffypix/model/status.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'views/search_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  SearchPageController createState() => SearchPageController();
}

class SearchPageController extends State<SearchPage> {
  final ScrollPhysics scrollPhysics = const ScrollPhysics();
  List<Status> timeline = [];
  final refreshController = RefreshController(initialRefresh: false);
  final TextEditingController textEditingController = TextEditingController();
  final scrollController = ScrollController();

  SearchResult? searchResult;

  bool loading = false;

  Timer? _cooldown;

  void searchQueryWithCooldown([_]) {
    _cooldown?.cancel();
    _cooldown = Timer(const Duration(milliseconds: 500), searchQuery);
  }

  void cancelSearch() {
    textEditingController.clear();
    searchQuery();
  }

  void searchQuery([_]) async {
    _cooldown?.cancel();
    if (textEditingController.text.isEmpty) {
      setState(() {
        searchResult = null;
        loading = false;
      });
      return;
    }
    final query = textEditingController.text.toLowerCase().trim();
    setState(() {
      loading = true;
    });
    try {
      final result = await FluffyPix.of(context).search(query);

      if (result.statuses.isEmpty) {
        result.statuses.addAll(
          timeline.where(
            (status) =>
                status.content != null &&
                status.content!.toLowerCase().contains(query),
          ),
        );
        if (result.hashtags.isNotEmpty && result.hashtags.first.name == query) {
          final statuses =
              await FluffyPix.of(context).requestTagTimeline(query);
          result.statuses.addAll(statuses);
        }
      }
      setState(() {
        searchResult = result;
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void goToHashtag(String tag) => Navigator.of(context).pushNamed('/tags/$tag');
  void goToUser(String id) => Navigator.of(context).pushNamed('/user/$id');

  void onUpdateStatus(Status? status, [String? deleteId]) {
    if (status == null) {
      setState(() {
        searchResult?.statuses.removeWhere((s) => s.id == deleteId);
      });
      return;
    }
    setState(() {
      searchResult?.statuses[searchResult!.statuses.indexWhere(
          (s) => s.id == status.id || s.reblog?.id == status.id)] = status;
    });
  }

  bool get usePublicTimeline => FluffyPix.of(context).usePublicTimeline;
  void setUsePublicTimeline(bool? b) {
    if (b == null) return;
    setState(() {
      FluffyPix.of(context).usePublicTimeline = b;
    });
    refreshController.requestRefresh();
  }

  bool get useDiscoverGridView => FluffyPix.of(context).useDiscoverGridView;
  void setUseDiscoverGridView(bool? b) {
    if (b == null) return;
    setState(() {
      FluffyPix.of(context).useDiscoverGridView = b;
    });
    refreshController.requestRefresh();
  }

  void refresh() async {
    if (textEditingController.text.isNotEmpty) {
      return searchQuery();
    }
    try {
      timeline = await FluffyPix.of(context).requestPublicTimeline(
        mediaOnly: useDiscoverGridView,
        local: !usePublicTimeline,
      );
      FluffyPix.of(context)
          .storeCachedTimeline<Status>('discover', timeline, (t) => t.toJson());
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
      final statuses = await FluffyPix.of(context).requestPublicTimeline(
        maxId: timeline.last.id,
        mediaOnly: useDiscoverGridView,
        local: !usePublicTimeline,
      );
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
            .getCachedTimeline<Status>('discover', (j) => Status.fromJson(j)) ??
        [];
  }

  @override
  Widget build(BuildContext context) => SearchPageView(this);
}
