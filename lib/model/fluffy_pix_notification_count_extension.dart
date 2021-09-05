import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_api_extension.dart';

import 'read_markers.dart';

extension FluffyPixNotificationCountExtension on FluffyPix {
  Future<int> getNotificationCount() async {
    unreadMarker ??= await getMarkers('notifications');
    final lastReadId = unreadMarker!.notifications?.lastReadId;
    if (lastReadId == null || lastReadId.isEmpty) return 0;
    unreadNotifications ??= (await getNotifications(sinceId: lastReadId)).chunk;
    return unreadNotifications!.length;
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
  }
}
