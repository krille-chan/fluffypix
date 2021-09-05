import 'dart:async';

import 'package:badges/badges.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_notification_count_extension.dart';
import 'package:flutter/material.dart';
import '../utils/int_short_string_extension.dart';

class NotificationCountBuilder extends StatefulWidget {
  final Widget Function(int) builder;
  const NotificationCountBuilder({required this.builder, Key? key})
      : super(key: key);

  @override
  _NotificationCountBuilderState createState() =>
      _NotificationCountBuilderState();
}

class _NotificationCountBuilderState extends State<NotificationCountBuilder> {
  late final StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = FluffyPix.of(context).onNotificationUpdate.stream.listen(
          (notification) => setState(() => FluffyPix.of(context)
              .unreadNotifications = notification == null ? [] : null),
        );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: FluffyPix.of(context).getNotificationCount(),
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
            child: widget.builder(unreadCount),
          );
        });
  }
}
