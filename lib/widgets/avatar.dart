import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final Account account;
  final double? radius;
  const Avatar({required this.account, this.radius, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(
        FluffyPix.of(context).allowAnimatedAvatars
            ? account.avatar
            : account.avatarStatic,
      ),
      radius: radius,
    );
  }
}
