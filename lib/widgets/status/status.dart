import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/status.dart';
import 'package:flutter/material.dart';

import 'text_status_content.dart';

class StatusWidget extends StatelessWidget {
  final Status status;

  const StatusWidget({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(status.account.avatar),
              ),
              SizedBox(width: 8),
              Text(status.account.displayName),
              Spacer(),
              PopupMenuButton(
                itemBuilder: (_) => [],
              ),
            ],
          ),
        ),
        TextStatusContent(status: status),
        Divider(height: 1, thickness: 1),
      ],
    );
  }
}
