import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/text_status_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class ImageStatusContent extends StatelessWidget {
  final Status status;

  const ImageStatusContent({Key? key, required this.status}) : super(key: key);

  Widget blurHashBuilder(_, __, ___) => SizedBox(
        height: 256,
        child: BlurHash(
            hash: status.mediaAttachments.first.blurhash ??
                AppConfigs.fallbackBlurHash),
      );
  @override
  Widget build(BuildContext context) {
    final attachment = status.mediaAttachments.first;

    final imageUrl = attachment.url?.toString();
    if (imageUrl == null) return TextStatusContent(status: status);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          progressIndicatorBuilder: blurHashBuilder,
          errorWidget: blurHashBuilder,
        ),
        if (attachment.description != null)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Text(
                '${status.account.displayName}: ${attachment.description}'),
          ),
      ],
    );
  }
}
