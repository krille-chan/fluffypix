import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

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
        status.mediaAttachments.first.url != null)) {
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
      return InkWell(
        onTap: () => Navigator.of(context).pushNamed('/status/${status.id}'),
        child: CachedNetworkImage(
          imageUrl: _imageUrl,
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
      return CachedNetworkImage(
        imageUrl: _imageUrl,
        width: imageStatusMode == ImageStatusMode.discover
            ? null
            : double.infinity,
        fit: BoxFit.cover,
        progressIndicatorBuilder: blurHashBuilder,
        errorWidget: blurHashBuilder,
        height: _type == ImageType.avatar ? 256 : null,
      );
    }
    return Container();
  }
}
