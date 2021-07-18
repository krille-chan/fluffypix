import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final Status status;

  const StatusWidget({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(status.account.avatar),
          ),
          title: Text(
            status.account.displayName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(status.createdAt),
        ),
        StatusContent(status: status),
        Row(
          children: [
            IconButton(
              icon: Icon(CupertinoIcons.heart),
              onPressed: () => null,
            ),
            IconButton(
              icon: Icon(CupertinoIcons.chat_bubble),
              onPressed: () => null,
            ),
            IconButton(
              icon: Icon(CupertinoIcons.share),
              onPressed: () => null,
            ),
            Spacer(),
            PopupMenuButton(
              itemBuilder: (_) => [],
            ),
          ],
        ),
        Divider(height: 1, thickness: 1),
      ],
    );
  }
}
