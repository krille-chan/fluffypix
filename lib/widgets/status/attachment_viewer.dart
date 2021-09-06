import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:video_player/video_player.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/media_attachment.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:fluffypix/widgets/status/status_content.dart';

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
    switch (attachment.type) {
      image:
      case MediaType.image:
        return _AttachmentImageViewer(
          attachment: attachment,
          imageStatusMode: imageStatusMode,
        );
      case MediaType.video:
        if (imageStatusMode == ImageStatusMode.discover) continue image;
        if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
          return _AttachVideoViewer(
            attachment: attachment,
            imageStatusMode: imageStatusMode,
          );
        }
        return _PlayInBrowserButton(
          attachment: attachment,
          imageStatusMode: imageStatusMode,
        );
      case MediaType.gifv:
      case MediaType.audio:
      case MediaType.unknown:
        if (imageStatusMode == ImageStatusMode.discover) continue image;
        return _PlayInBrowserButton(
          attachment: attachment,
          imageStatusMode: imageStatusMode,
        );
    }
  }
}

class _AttachVideoViewer extends StatefulWidget {
  final MediaAttachment attachment;
  final ImageStatusMode imageStatusMode;
  const _AttachVideoViewer({
    required this.attachment,
    required this.imageStatusMode,
    Key? key,
  }) : super(key: key);

  @override
  __AttachVideoViewerState createState() => __AttachVideoViewerState();
}

class __AttachVideoViewerState extends State<_AttachVideoViewer> {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.attachment.url.toString());
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: !FluffyPix.of(context).displayThumbnailsOnly,
          looping: true,
        )..setVolume(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chewie = _chewieController;
    if (chewie == null) {
      return _AttachmentImageViewer(
          attachment: widget.attachment,
          imageStatusMode: widget.imageStatusMode);
    }
    final width = AppThemes.isColumnMode(context)
        ? AppThemes.columnWidth * 2
        : MediaQuery.of(context).size.width;
    return SizedBox(
        width: width,
        height: widget.attachment.videoMeta.small?.aspect == null
            ? width
            : width / widget.attachment.videoMeta.small!.aspect!,
        child: Chewie(controller: chewie));
  }
}

class _AttachmentImageViewer extends StatelessWidget {
  final MediaAttachment attachment;
  final ImageStatusMode imageStatusMode;
  const _AttachmentImageViewer({
    required this.attachment,
    required this.imageStatusMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = AppThemes.isColumnMode(context)
        ? AppThemes.columnWidth * 2
        : MediaQuery.of(context).size.width;
    final thumbnailOnly = attachment.type != MediaType.image ||
        imageStatusMode == ImageStatusMode.discover ||
        FluffyPix.of(context).displayThumbnailsOnly;
    final metaInfo = thumbnailOnly
        ? attachment.imageMeta.small ?? attachment.imageMeta.original
        : attachment.imageMeta.original;
    return CachedNetworkImage(
      imageUrl: thumbnailOnly
          ? attachment.previewUrl.toString()
          : attachment.url.toString(),
      placeholder: imageStatusMode == ImageStatusMode.discover
          ? null
          : (_, __) => const Center(child: CupertinoActivityIndicator()),
      errorWidget: (_, __, [___]) =>
          BlurHash(hash: attachment.blurhash ?? AppConfigs.fallbackBlurHash),
      width:
          imageStatusMode == ImageStatusMode.discover ? double.infinity : width,
      height: imageStatusMode == ImageStatusMode.discover
          ? double.infinity
          : metaInfo?.aspect == null
              ? width
              : width / metaInfo!.aspect!,
      fit: imageStatusMode == ImageStatusMode.discover
          ? BoxFit.cover
          : BoxFit.contain,
    );
  }
}

class _PlayInBrowserButton extends StatelessWidget {
  final MediaAttachment attachment;
  final ImageStatusMode imageStatusMode;
  const _PlayInBrowserButton({
    required this.attachment,
    required this.imageStatusMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = AppThemes.isColumnMode(context)
        ? AppThemes.columnWidth * 2
        : MediaQuery.of(context).size.width;
    final metaInfo =
        attachment.imageMeta.small ?? attachment.imageMeta.original;
    return SizedBox(
      width: width,
      height: metaInfo?.aspect == null ? width : width / metaInfo!.aspect!,
      child: Stack(
        children: [
          _AttachmentImageViewer(
            attachment: attachment,
            imageStatusMode: imageStatusMode,
          ),
          Center(
            child: FloatingActionButton.extended(
              heroTag: null,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).primaryColor,
              icon: const Icon(CupertinoIcons.videocam),
              label: Text(L10n.of(context)!.playInBrowser),
              onPressed: () => linksCallback(
                attachment.url.toString(),
                context,
              ),
            ),
          )
        ],
      ),
    );
  }
}
