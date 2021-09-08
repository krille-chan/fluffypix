import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';

enum ImageType { image, avatar, missing }

class TextStatusContent extends StatelessWidget {
  final Status status;
  final ImageStatusMode imageStatusMode;

  const TextStatusContent({
    Key? key,
    required this.status,
    required this.imageStatusMode,
  }) : super(key: key);

  String _imageUrl(BuildContext context) {
    final author = status.reblog?.account ?? status.account;
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
        !status.mediaAttachments.first.url
            .toString()
            .endsWith('missing.png'))) {
      return ImageType.image;
    }
    if (status.account.headerStatic.isNotEmpty &&
            !status.account.headerStatic.endsWith('missing.png') ||
        status.account.avatarStatic.isNotEmpty) {
      return ImageType.avatar;
    }
    return ImageType.missing;
  }

  @override
  Widget build(BuildContext context) {
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
      final width = AppThemes.isColumnMode(context)
          ? AppThemes.mainColumnWidth
          : MediaQuery.of(context).size.width;

      return CachedNetworkImage(
        imageUrl: _imageUrl(context),
        width: double.infinity,
        fit: BoxFit.cover,
        height: imageStatusMode == ImageStatusMode.discover
            ? null
            : min(width * 1 / 2, 160),
        placeholder: (_, __) => SizedBox(
          height: imageStatusMode == ImageStatusMode.discover
              ? null
              : width * 1 / 2,
          child: const Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      );
    }
    return Container();
  }
}
