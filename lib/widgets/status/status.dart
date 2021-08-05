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
              IconButton(
                icon: Icon(
                  status.favourited
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: status.favourited ? Colors.red : null,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.chat_bubble),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                    status.reblogged
                        ? CupertinoIcons.share_solid
                        : CupertinoIcons.share,
                    color: status.reblogged ? Colors.green : null),
                onPressed: () {},
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
