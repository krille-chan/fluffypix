import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:elliptic/elliptic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/push_subscription.dart';
import '../utils/convert_to_json.dart';
import 'fluffy_pix.dart';
import 'fluffy_pix_api_extension.dart';
import 'fluffy_pix_notification_count_extension.dart';
import 'push_credentials.dart';

extension FluffyPixPushExtension on FluffyPix {
  static hex(int c) {
    if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
      return c - '0'.codeUnitAt(0);
    }
    if (c >= 'A'.codeUnitAt(0) && c <= 'F'.codeUnitAt(0)) {
      return (c - 'A'.codeUnitAt(0)) + 10;
    }
  }

  static Uint8List toUnitList(String str) {
    int length = str.length;
    if (length % 2 != 0) {
      str = "0" + str;
      length++;
    }
    List<int> s = str.toUpperCase().codeUnits;
    Uint8List bArr = Uint8List(length >> 1);
    for (int i = 0; i < length; i += 2) {
      bArr[i >> 1] = ((hex(s[i]) << 4) | hex(s[i + 1]));
    }
    return bArr;
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<void> initPush() async {
    await Firebase.initializeApp();
    final messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen(_handleForegroundRemoteMessage);

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
      debugPrint('Notification permissions have been declined. Stop initPush!');
      return;
    }

    late final String? token;
    try {
      token = await messaging.getToken();
      if (token == null) throw 'Token is NULL';
    } catch (e, s) {
      debugPrint('Unable to get Firebase Messaging token!$e $s');
      rethrow;
    }

    final pushCredentials = await loadCredentials(box);
    if (pushCredentials != null &&
        pushCredentials.endpoint == AppConfigs.pushGatewayUrl &&
        pushCredentials.token == token) {
      debugPrint('Push notifications already initialized!');
      return;
    }

    final newKey = getP256().generatePrivateKey();
    final privateKey = const Base64Encoder().convert(
      await toUnitList(newKey.toString()),
    );
    final publicKey = const Base64Encoder().convert(
      await toUnitList(newKey.publicKey.toString()),
    );
    final auth = getRandString(16);

    final platform = kIsWeb
        ? 'web'
        : Platform.isIOS
            ? 'ios'
            : Platform.isAndroid
                ? 'android'
                : 'unknown';

    final endpoint = '${AppConfigs.pushGatewayUrl}/$platform/$token';

    await setPushSubcription(
      endpoint,
      publicKey,
      auth,
      alerts: PushSubscriptionAlerts(
        follow: true,
        favourite: true,
        reblog: true,
        mention: true,
        poll: true,
      ),
    );

    await _saveCredentials(PushCredentials(
      token: token,
      publickey: publicKey,
      privatekey: privateKey,
      auth: auth,
      endpoint: AppConfigs.pushGatewayUrl,
    ));
    debugPrint('Push notifications initialized!');
  }

  _handleForegroundRemoteMessage(RemoteMessage message) {
    print('Got remote message');
    print(message.data);
    unreadNotifications = null;
    updateNotificationCount();
  }
/*
  static Future<void> _handleRemoteMessage(RemoteMessage message, [Box? box]) async {
    debugPrint('New remote message');
      final String? cipherText = message.data['ciphertext'];

    if (cipherText == null) {
      // Display fallback notification
      return;
    }
    final credentials = await loadCredentials(box);
    if (credentials == null) {
      debugPrint('Received Push Notifications but no private key found');
      return;
    }

    final publicKey = await EcdhPublicKey.importRawKey(
      const Base64Decoder().convert(credentials.publickey),
      EllipticCurve.p256,
    );

    final privateKey = await EcdhPrivateKey.importPkcs8Key(
      const Base64Decoder().convert(credentials.privatekey),
      EllipticCurve.p256,
    );

    final derivedBits = await privateKey.deriveBits(16, publicKey);

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ));
    }
    return;
  }*/

  static Future<PushCredentials?> loadCredentials([Box? box]) async {
    var closeAfterGet = false;
    if (box == null) {
      await Hive.initFlutter();
      box = await Hive.openBox(AppConfigs.hiveBoxName);
      closeAfterGet = true;
    }
    final raw = box.get('pushCredentials');
    if (closeAfterGet) await box.close();
    if (raw == null) return null;
    try {
      return PushCredentials.fromJson((raw as Map).toJson());
    } catch (_) {
      debugPrint('Push credentials in Hive box are compromised!');
      box.delete('pushCredentials');
    }
    return null;
  }

  Future<void> _saveCredentials(PushCredentials credentials) => box.put(
        'pushCredentials',
        credentials.toJson(),
      );
}

extension RemoteMessageDecryptExtension on RemoteMessage {
  //Future<PushNotification> decrypt([Box? box]) async {}
}
