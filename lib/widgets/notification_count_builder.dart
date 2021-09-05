import 'package:badges/badges.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/material.dart';
import '../utils/int_short_string_extension.dart';

class NotificationCountBuilder extends StatelessWidget {
  final Widget Function(int) builder;
  const NotificationCountBuilder({required this.builder, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: FluffyPix.of(context).onNotificationCount.stream,
        builder: (context, snapshot) {
          final unreadCount = snapshot.data ?? 0;
          return Badge(
            showBadge: unreadCount > 0,
            badgeColor: Colors.red,
            position: BadgePosition.topEnd(top: -16, end: -16),
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(8),
            badgeContent: Text(
              unreadCount.shortString,
              style: const TextStyle(color: Colors.white),
            ),
            child: builder(unreadCount),
          );
        });
  }
}
