import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluffypix/model/fluffy_pix.dart';

extension FluffyPixPushExtension on FluffyPix {
  Future<void> initPush() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log('Notification permissions have been declined. Stop initPush!');
      return;
    }

    late final String? token;
    try {
      token = await messaging.getToken();
      if (token == null) throw 'Token is NULL';
    } catch (e, s) {
      log('Unable to get Firebase Messaging token!', error: e, stackTrace: s);
      rethrow;
    }

    //print('Got firebase token: $token');
  }
}
