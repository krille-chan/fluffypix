import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';

enum ImageType { image, avatar, missing }

class ImageStatusContent extends StatelessWidget {
  final Status status;
  final ImageStatusMode imageStatusMode;

  const ImageStatusContent({
    Key? key,
    required this.status,
    required this.imageStatusMode,
  }) : super(key: key);

  String get _imageUrl {
    if (status.mediaAttachments.isNotEmpty &&
        status.mediaAttachments.first.url != null) {
      if (imageStatusMode == ImageStatusMode.discover &&
          status.mediaAttachments.first.previewUrl != null) {
        return status.mediaAttachments.first.previewUrl!.toString();
      }
      return status.mediaAttachments.first.url!.toString();
    }
    if (status.card?.image != null) {
      return status.card!.image!;
    }
    if (status.account.header.isNotEmpty &&
        !status.account.header.endsWith('missing.png')) {
      return status.account.header;
    }
    if (status.account.avatar.isNotEmpty) {
      return status.account.avatar;
    }
    return '';
  }

  ImageType get _type {
    if ((status.mediaAttachments.isNotEmpty &&
            status.mediaAttachments.first.url != null) ||
        status.card?.image != null) {
      return ImageType.image;
    }
    if (status.account.header.isNotEmpty &&
            !status.account.header.endsWith('missing.png') ||
        status.account.avatar.isNotEmpty) {
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
      return CachedNetworkImage(
        imageUrl: _imageUrl,
        progressIndicatorBuilder: blurHashBuilder,
        errorWidget: blurHashBuilder,
        fit: BoxFit.cover,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_type == ImageType.missing)
          Center(
              child: Image.asset(
            'assets/images/logo.png',
            width: 56,
            height: 56,
          )),
        if (_type != ImageType.missing &&
            (imageStatusMode != ImageStatusMode.reply ||
                _type == ImageType.image))
          CachedNetworkImage(
            imageUrl: _imageUrl,
            width: imageStatusMode == ImageStatusMode.discover
                ? null
                : double.infinity,
            fit: BoxFit.cover,
            progressIndicatorBuilder: blurHashBuilder,
            errorWidget: blurHashBuilder,
            height: _type == ImageType.avatar ? 256 : null,
          ),
        if (imageStatusMode != ImageStatusMode.discover)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: RichText(
              text: HTML.toTextSpan(
                  context,
                  '<b>${status.account.displayName}</b>: ' +
                      (status.content ?? ''),
                  linksCallback: (link) => launch(link),
                  defaultTextStyle: const TextStyle(fontSize: 14),
                  overrideStyle: {
                    'a': TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                    ),
                  }),
            ),
          ),
      ],
    );
  }
}
