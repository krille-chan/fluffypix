import 'dart:async';
import 'dart:io';

import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/relationships.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:share/share.dart';

import 'views/user_view.dart';

enum UserViewColumn { statuses, followers, following }
enum UserStatusesView { grid, timeline }

class UserPage extends StatefulWidget {
  final String id;
  const UserPage({required this.id, Key? key}) : super(key: key);

  @override
  UserPageController createState() => UserPageController();
}

class UserPageController extends State<UserPage> {
  final ScrollPhysics scrollPhysics = const ScrollPhysics();
  UserViewColumn column = UserViewColumn.statuses;
  UserStatusesView userStatusesView = UserStatusesView.grid;
  Account? account;
  bool get isOwnUser => FluffyPix.of(context).ownAccount?.id == widget.id;

  List<Status>? timeline;
  List<Account>? followers;
  List<Account>? following;
  Relationships? relationships;

  String? nextFollowers;
  String? nextFollowing;

  bool loadFollowChanges = false;

  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();

  void refresh() async {
    try {
      account ??= await FluffyPix.of(context).loadAccount(widget.id);
      if (!isOwnUser) {
        relationships ??=
            await FluffyPix.of(context).getRelationship(widget.id);
      }
      switch (column) {
        case UserViewColumn.statuses:
          timeline = await FluffyPix.of(context).requestUserTimeline(
            widget.id,
            onlyMedia: userStatusesView == UserStatusesView.grid,
          );
          break;
        case UserViewColumn.followers:
          final chunk = await FluffyPix.of(context).requestFollowers(widget.id);
          followers = chunk.chunk;
          nextFollowers = chunk.next;
          break;
        case UserViewColumn.following:
          final chunk = await FluffyPix.of(context).requestFollowing(widget.id);
          following = chunk.chunk;
          nextFollowing = chunk.next;
          break;
      }
      setState(() {});
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
      if (timeline == null) {
        Timer(const Duration(seconds: 3), refreshController.requestRefresh);
      }
      rethrow;
    }
  }

  void onUpdateStatus(Status? status, [String? deleteId]) {
    if (status == null) {
      setState(() {
        timeline!.removeWhere((s) => s.id == deleteId);
      });
      return;
    }
    final index = timeline!
        .indexWhere((s) => s.id == status.id || s.reblog?.id == status.id);
    if (index == -1) {
      refreshController.requestRefresh();
    } else {
      setState(() {
        timeline![index] = status;
      });
    }
  }

  void loadMore() async {
    try {
      switch (column) {
        case UserViewColumn.statuses:
          final statuses = await FluffyPix.of(context).requestUserTimeline(
            widget.id,
            maxId: timeline!.last.id,
            excludeReplies: userStatusesView == UserStatusesView.grid,
            onlyMedia: userStatusesView == UserStatusesView.grid,
          );
          timeline!.addAll(statuses);
          break;
        case UserViewColumn.followers:
          final users = await FluffyPix.of(context).requestFollowers(
            widget.id,
            maxId: nextFollowers,
          );
          nextFollowers = users.next;
          followers!.addAll(users.chunk);
          break;
        case UserViewColumn.following:
          final users = await FluffyPix.of(context).requestFollowing(
            widget.id,
            maxId: nextFollowing,
          );
          nextFollowing = users.next;
          following!.addAll(users.chunk);
          break;
      }
      setState(() {});
      refreshController.loadComplete();
    } catch (_) {
      refreshController.loadFailed();
      rethrow;
    }
  }

  void onPopupAction(PopupActions action) async {
    final snackBar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.of(context)!.loading),
        duration: const Duration(seconds: 30),
      ),
    );
    try {
      late final Relationships newRelationships;
      switch (action) {
        case PopupActions.block:
          if ((relationships?.blocking ?? false)) {
            newRelationships = await FluffyPix.of(context).unblock(account!.id);
          } else {
            newRelationships = await FluffyPix.of(context).block(account!.id);
          }
          break;
        case PopupActions.mute:
          if ((relationships?.muting ?? false)) {
            newRelationships = await FluffyPix.of(context).unmute(account!.id);
          } else {
            newRelationships = await FluffyPix.of(context).mute(account!.id);
          }
          break;
        case PopupActions.website:
          linksCallback(account!.url, context);
          break;
        case PopupActions.share:
          if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
            Share.share(account!.url);
          } else {
            Clipboard.setData(ClipboardData(text: account!.url));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(L10n.of(context)!.copiedToClipboard),
              ),
            );
          }
          break;
      }
      snackBar.close();
      setState(() {
        relationships = newRelationships;
      });
    } catch (_) {
      snackBar.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    }
  }

  void follow() => _setFollowStatus(true);
  void unfollow() => _setFollowStatus(false);

  void _setFollowStatus(bool follow) async {
    setState(() {
      loadFollowChanges = true;
    });
    try {
      final newRelationships = follow
          ? await FluffyPix.of(context).follow(widget.id)
          : await FluffyPix.of(context).unfollow(widget.id);
      setState(() {
        relationships = newRelationships;
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
        loadFollowChanges = false;
      });
    }
  }

  void setStatusesGridView() {
    if (userStatusesView == UserStatusesView.grid) return;
    setState(() {
      timeline = null;
      userStatusesView = UserStatusesView.grid;
    });
    refreshController.requestRefresh();
  }

  void setStatusesTimelineView() {
    if (userStatusesView == UserStatusesView.timeline) return;
    setState(() {
      timeline = null;
      userStatusesView = UserStatusesView.timeline;
    });
    refreshController.requestRefresh();
  }

  void goToSettings() => Navigator.of(context).pushNamed('/settings');

  void goToProfile(String id) => Navigator.of(context).pushNamed('/user/$id');

  void setColumnStatuses() => _setColumnTo(UserViewColumn.statuses);

  void setColumnFollowers() => _setColumnTo(UserViewColumn.followers);

  void setColumnFollowing() => _setColumnTo(UserViewColumn.following);

  void _setColumnTo(UserViewColumn newColumn) {
    if (column == newColumn) return;
    setState(() {
      column = newColumn;
    });
    refreshController.requestRefresh();
  }

  void sendMessage() =>
      Navigator.of(context).pushNamed('/compose', arguments: account);

  @override
  void initState() {
    super.initState();
    if (isOwnUser) {
      account = FluffyPix.of(context).ownAccount;
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) => UserPageView(this);
}
