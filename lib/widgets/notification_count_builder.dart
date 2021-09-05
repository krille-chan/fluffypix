import 'package:badges/badges.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/material.dart';
import '../utils/int_short_string_extension.dart';

class NotificationCountBuilder extends StatelessWidget {
  final Widget Function(int) builder;
  const NotificationCountBuilder({required this.builder, Key? key})
      : super(key: key);

  static int lastCount = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: FluffyPix.of(context).onNotificationCount.stream,
        builder: (context, snapshot) {
          final unreadCount = snapshot.data ?? lastCount;
          lastCount = unreadCount;
          return Badge(
            showBadge: unreadCount > 0,
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.all(2),
            badgeColor: Colors.red[700]!,
            shape: BadgeShape.square,
            badgeContent: Text(
              unreadCount.shortString,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: builder(unreadCount),
          );
        });
  }
}
