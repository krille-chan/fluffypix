import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';

class Avatar extends StatelessWidget {
  final Account account;
  final double? radius;
  const Avatar({required this.account, this.radius, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      CupertinoIcons.person_fill,
      color: Theme.of(context).textTheme.bodyText1?.color,
    );
    return CircleAvatar(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 64),
        child: CachedNetworkImage(
          imageUrl: FluffyPix.of(context).allowAnimatedAvatars
              ? account.avatar
              : account.avatarStatic,
          fit: BoxFit.fill,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => placeholder,
        ),
      ),
      radius: radius,
    );
  }
}
