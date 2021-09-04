import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/media_attachment.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/material.dart';

class AttachmentViewer extends StatelessWidget {
  final MediaAttachment attachment;
  final ImageStatusMode imageStatusMode;
  const AttachmentViewer({
    required this.attachment,
    required this.imageStatusMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbnailOnly = imageStatusMode == ImageStatusMode.discover ||
        FluffyPix.of(context).displayThumbnailsOnly;
    final width =
        (MediaQuery.of(context).size.width > (NavScaffold.columnWidth * 3 + 3))
            ? NavScaffold.columnWidth * 2
            : MediaQuery.of(context).size.width;
    switch (attachment.type) {
      image:
      case MediaType.image:
      case MediaType.unknown:
        final metaInfo = thumbnailOnly
            ? attachment.imageMeta.small ?? attachment.imageMeta.original
            : attachment.imageMeta.original;
        return CachedNetworkImage(
          imageUrl: thumbnailOnly
              ? attachment.previewUrl.toString()
              : attachment.url.toString(),
          width: imageStatusMode == ImageStatusMode.discover ? null : width,
          height: metaInfo?.aspect == null ? width : width / metaInfo!.aspect!,
          fit: BoxFit.fill,
        );
      case MediaType.video:
        // TODO: Handle this case.
        continue image;
      case MediaType.gifv:
        // TODO: Handle this case.
        continue image;
      case MediaType.audio:
        // TODO: Handle this case.
        continue image;
    }
  }
}
