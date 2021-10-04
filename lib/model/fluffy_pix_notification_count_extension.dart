import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_api_extension.dart';
import 'read_markers.dart';

extension FluffyPixNotificationCountExtension on FluffyPix {
  Future<int> _getNotificationCount() async {
    unreadMarker ??= await getMarkers('notifications');
    final lastReadId = unreadMarker!.notifications?.lastReadId;
    if (lastReadId == null || lastReadId.isEmpty) return 0;
    unreadNotifications ??= (await getNotifications(sinceId: lastReadId)).chunk;
    return unreadNotifications!.length;
  }

  void updateNotificationCount() async {
    if (!isLogged) return;
    final count = await _getNotificationCount();
    onNotificationCount.sink.add(count);
    if (count == 0) {
      FlutterAppBadger.removeBadge();
      FlutterLocalNotificationsPlugin().cancelAll();
    }
  }

  Future<void> markNotificationsAsRead() async {
    if (unreadNotifications?.isEmpty ?? true) return;
    final lastNotificationId = unreadNotifications!.first.id;
    unreadMarker = await setMarkers(
      ReadMarkers(
        notifications: ReadMarker(lastReadId: lastNotificationId),
      ),
    );
    unreadNotifications = [];
    updateNotificationCount();
  }
}
