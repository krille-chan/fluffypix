import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/text_status_content.dart';
import 'package:flutter/material.dart';

class ImageStatusContent extends StatelessWidget {
  final Status status;

  const ImageStatusContent({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final attachment = status.mediaAttachments.first;
    final imageUrl =
        attachment.previewUrl?.toString() ?? attachment.url?.toString();
    if (imageUrl == null) return TextStatusContent(status: status);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        if (attachment.description != null)
          ListTile(
              title: Text(
                  '${status.account.displayName}: ${attachment.description}')),
      ],
    );
  }
}
