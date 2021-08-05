import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/date_time_extension.dart';

class StatusWidget extends StatelessWidget {
  final Status status;

  const StatusWidget({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const badgeTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    final badgePosition = BadgePosition.topEnd(top: 0, end: 0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(status.account.avatar),
          ),
          title: Text(
            status.account.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(status.createdAt.localizedTimeShort(context)),
        ),
        StatusContent(status: status),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Badge(
                badgeContent: Text(
                  status.favouritesCount.shortString,
                  style: badgeTextStyle,
                ),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(6),
                padding: const EdgeInsets.all(2),
                position: badgePosition,
                badgeColor: Theme.of(context).appBarTheme.color!,
                showBadge: status.favouritesCount > 0,
                child: IconButton(
                  icon: Icon(
                    status.favourited
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: status.favourited ? Colors.red : null,
                  ),
                  onPressed: () {},
                ),
              ),
              Badge(
                badgeContent: Text(
                  status.repliesCount.shortString,
                  style: badgeTextStyle,
                ),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(6),
                padding: const EdgeInsets.all(2),
                position: badgePosition,
                showBadge: status.repliesCount > 0,
                badgeColor: Theme.of(context).appBarTheme.color!,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chat_bubble),
                  onPressed: () {},
                ),
              ),
              Badge(
                badgeContent: Text(
                  status.reblogsCount.shortString,
                  style: badgeTextStyle,
                ),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(6),
                padding: const EdgeInsets.all(2),
                showBadge: status.reblogsCount > 0,
                badgeColor: Theme.of(context).appBarTheme.color!,
                position: badgePosition,
                child: IconButton(
                  icon: Icon(
                      status.reblogged
                          ? CupertinoIcons.share_solid
                          : CupertinoIcons.share,
                      color: status.reblogged ? Colors.green : null),
                  onPressed: () {},
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (_) => [],
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

extension on int {
  String get shortString {
    if (this < 1000) return toString();
    if (this < 1000000) return '${toString()}k';
    return '${toString()}m';
  }
}
