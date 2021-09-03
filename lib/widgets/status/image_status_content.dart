import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:simple_html_css/simple_html_css.dart';

enum ImageType { image, avatar, missing }

class ImageStatusContent extends StatelessWidget {
  final Status status;
  final ImageStatusMode imageStatusMode;

  const ImageStatusContent({
    Key? key,
    required this.status,
    required this.imageStatusMode,
  }) : super(key: key);

  String _imageUrl(BuildContext context) {
    final author = status.reblog?.account ?? status.account;
    if (status.mediaAttachments.isNotEmpty &&
        status.mediaAttachments.first.url != null) {
      if ((imageStatusMode == ImageStatusMode.discover ||
              FluffyPix.of(context).displayThumbnailsOnly) &&
          status.mediaAttachments.first.previewUrl != null) {
        return status.mediaAttachments.first.previewUrl!.toString();
      }
      return status.mediaAttachments.first.url!.toString();
    }
    if (status.card?.image != null) {
      return status.card!.image!;
    }
    if (author.headerStatic.isNotEmpty &&
        !author.headerStatic.endsWith('missing.png')) {
      return author.headerStatic;
    }
    return author.avatarStatic;
  }

  ImageType get _type {
    if ((status.mediaAttachments.isNotEmpty &&
        status.mediaAttachments.first.url != null)) {
      return ImageType.image;
    }
    if (status.account.headerStatic.isNotEmpty &&
            !status.account.headerStatic.endsWith('missing.png') ||
        status.account.avatarStatic.isNotEmpty) {
      return ImageType.avatar;
    }
    return ImageType.missing;
  }

  Widget blurHashBuilder(_, __, ___) => SizedBox(
        height: imageStatusMode == ImageStatusMode.discover ? null : 256,
        child: Stack(
          children: [
            BlurHash(
                hash: status.mediaAttachments.isEmpty
                    ? AppConfigs.fallbackBlurHash
                    : status.mediaAttachments.first.blurhash ??
                        AppConfigs.fallbackBlurHash),
            if (imageStatusMode != ImageStatusMode.discover)
              const Center(child: CupertinoActivityIndicator()),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    if (imageStatusMode == ImageStatusMode.discover) {
      return InkWell(
        onTap: () => Navigator.of(context).pushNamed('/status/${status.id}'),
        child: CachedNetworkImage(
          imageUrl: _imageUrl(context),
          progressIndicatorBuilder: blurHashBuilder,
          errorWidget: blurHashBuilder,
          fit: BoxFit.cover,
        ),
      );
    }
    if (_type == ImageType.missing) {
      return Center(
          child: Image.asset(
        'assets/images/logo.png',
        width: 56,
        height: 56,
      ));
    }
    if (_type != ImageType.missing &&
        (imageStatusMode != ImageStatusMode.reply ||
            _type == ImageType.image)) {
      final displayBigText =
          status.mediaAttachments.isEmpty && status.card?.image == null;
      return Stack(
        children: [
          if (!displayBigText)
            CachedNetworkImage(
              imageUrl: _imageUrl(context),
              width: imageStatusMode == ImageStatusMode.discover
                  ? null
                  : double.infinity,
              fit: BoxFit.fill,
              progressIndicatorBuilder: blurHashBuilder,
              errorWidget: blurHashBuilder,
            ),
          if (displayBigText)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.15), BlendMode.dstATop),
                  image: CachedNetworkImageProvider(
                    _imageUrl(context),
                  ),
                ),
              ),
              constraints: const BoxConstraints(minHeight: 256),
              alignment: Alignment.center,
              child: RichText(
                text: HTML.toTextSpan(context, status.content ?? '',
                    linksCallback: (link) => linksCallback(link, context),
                    defaultTextStyle: const TextStyle(fontSize: 21),
                    overrideStyle: {
                      'a': TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.none,
                      ),
                    }),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    }
    return Container();
  }
}
