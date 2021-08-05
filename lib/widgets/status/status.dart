import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/date_time_extension.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class StatusWidget extends StatefulWidget {
  final Status status;
  final List<Status> replies;
  final void Function(Status status) onUpdate;

  const StatusWidget({
    Key? key,
    required this.status,
    required this.onUpdate,
    this.replies = const [],
  }) : super(key: key);

  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  bool _favoriteLoading = false;
  bool _shareLoading = false;

  void favoriteAction() async {
    setState(() => _favoriteLoading = true);
    try {
      final status = await (widget.status.favourited ?? false
          ? FluffyPix.of(context).unfavoriteStatus(widget.status.id)
          : FluffyPix.of(context).favoriteStatus(widget.status.id));
      widget.onUpdate(status);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() => _favoriteLoading = false);
    }
  }

  void shareAction() async {
    setState(() => _shareLoading = true);
    try {
      final status = await (widget.status.reblogged ?? false
          ? FluffyPix.of(context).unboostStatus(widget.status.id)
          : FluffyPix.of(context).boostStatus(widget.status.id));
      widget.onUpdate(status);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() => _shareLoading = false);
    }
  }

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
            backgroundImage:
                CachedNetworkImageProvider(widget.status.account.avatar),
          ),
          title: Text(
            widget.status.account.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(widget.status.createdAt.localizedTimeShort(context)),
        ),
        StatusContent(status: widget.status),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _favoriteLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CupertinoActivityIndicator(),
                    )
                  : Badge(
                      badgeContent: Text(
                        widget.status.favouritesCount.shortString,
                        style: badgeTextStyle,
                      ),
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.all(2),
                      position: badgePosition,
                      badgeColor: Theme.of(context).appBarTheme.color!,
                      showBadge: widget.status.favouritesCount > 0,
                      child: IconButton(
                        icon: Icon(
                          widget.status.favourited ?? false
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: widget.status.favourited ?? false
                              ? Colors.red
                              : null,
                        ),
                        onPressed: favoriteAction,
                      ),
                    ),
              Badge(
                badgeContent: Text(
                  widget.status.repliesCount.shortString,
                  style: badgeTextStyle,
                ),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(6),
                padding: const EdgeInsets.all(2),
                position: badgePosition,
                showBadge: widget.status.repliesCount > 0,
                badgeColor: Theme.of(context).appBarTheme.color!,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chat_bubble),
                  onPressed: () {},
                ),
              ),
              _shareLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CupertinoActivityIndicator(),
                    )
                  : Badge(
                      badgeContent: Text(
                        widget.status.reblogsCount.shortString,
                        style: badgeTextStyle,
                      ),
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.all(2),
                      showBadge: widget.status.reblogsCount > 0,
                      badgeColor: Theme.of(context).appBarTheme.color!,
                      position: badgePosition,
                      child: IconButton(
                        icon: Icon(
                            widget.status.reblogged ?? false
                                ? CupertinoIcons.share_solid
                                : CupertinoIcons.share,
                            color: widget.status.reblogged ?? false
                                ? Colors.green
                                : null),
                        onPressed: shareAction,
                      ),
                    ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (_) => [],
              ),
            ],
          ),
        ),
        for (final reply in widget.replies)
          ListTile(
            title: Text('${reply.account.displayName}: ${reply.content}'),
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
