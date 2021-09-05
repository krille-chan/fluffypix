import 'package:fluffypix/model/notification.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:fluffypix/widgets/avatar.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../notifications.dart';
import '../../utils/date_time_extension.dart';

class NotificationsPageView extends StatelessWidget {
  final NotificationsPageController controller;

  const NotificationsPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: controller.timeline.isNotEmpty,
        onRefresh: controller.refresh,
        onLoading: controller.loadMore,
        child: controller.timeline.isEmpty
            ? Center(child: Text(L10n.of(context)!.suchEmpty))
            : ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.timeline.length,
                itemBuilder: (context, i) => ListTile(
                  leading: InkWell(
                    borderRadius: BorderRadius.circular(64),
                    onTap: () => controller
                        .goToProfile(controller.timeline[i].account.id),
                    child: Avatar(account: controller.timeline[i].account),
                  ),
                  title: RichText(
                    text: HTML.toTextSpan(context,
                        controller.timeline[i].toLocalizedString(context),
                        linksCallback: (link) => linksCallback(link, context),
                        defaultTextStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        overrideStyle: {
                          'a': TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none,
                          ),
                        }),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        controller.timeline[i].iconData,
                        size: 16,
                        color: controller.timeline[i].color,
                      ),
                      const SizedBox(width: 4),
                      Text(controller.timeline[i].createdAt
                          .localizedTimeShort(context)),
                    ],
                  ),
                  trailing: controller.timeline[i].status == null
                      ? ElevatedButton(
                          child: Text(L10n.of(context)!.follow),
                          onPressed: () => controller
                              .goToProfile(controller.timeline[i].account.id),
                        )
                      : SizedBox(
                          width: 42,
                          height: 42,
                          child: StatusContent(
                            status: controller.timeline[i].status!,
                            imageStatusMode: ImageStatusMode.discover,
                          ),
                        ),
                ),
              ),
      ),
      currentIndex: 3,
      scrollController: controller.scrollController,
    );
  }
}

extension on PushNotification {
  String toLocalizedString(BuildContext context) {
    switch (type) {
      case NotificationType.mention:
        return L10n.of(context)!
            .mentioned(account.calcedDisplayname, status?.content ?? '');
      case NotificationType.favourite:
        return L10n.of(context)!.likesYourPost(account.calcedDisplayname);
      case NotificationType.follow:
        return L10n.of(context)!.isFollowingYouNow(account.calcedDisplayname);
      case NotificationType.follow_request:
        return L10n.of(context)!
            .wouldLikeToFollowYou(account.calcedDisplayname);
      case NotificationType.reblog:
        return L10n.of(context)!.sharedYourPost(account.calcedDisplayname);
      case NotificationType.poll:
        return L10n.of(context)!.pollEnded;
      case NotificationType.status:
        return L10n.of(context)!.hasPosted(account.calcedDisplayname);
    }
  }

  Color? get color {
    switch (type) {
      case NotificationType.mention:
        return Colors.orange[700];
      case NotificationType.favourite:
        return Colors.red[700];
      case NotificationType.reblog:
        return Colors.green[700];
      case NotificationType.follow:
        return Colors.blue[700];
      case NotificationType.follow_request:
      case NotificationType.poll:
      case NotificationType.status:
        return null;
    }
  }

  IconData get iconData {
    switch (type) {
      case NotificationType.mention:
        return CupertinoIcons.chat_bubble_fill;
      case NotificationType.favourite:
        return CupertinoIcons.heart_fill;
      case NotificationType.follow:
        return CupertinoIcons.square_favorites_alt_fill;
      case NotificationType.follow_request:
        return CupertinoIcons.square_favorites_alt;
      case NotificationType.reblog:
        return CupertinoIcons.repeat;
      case NotificationType.poll:
        return CupertinoIcons.info_circle_fill;
      case NotificationType.status:
        return CupertinoIcons.bell_circle_fill;
    }
  }
}
