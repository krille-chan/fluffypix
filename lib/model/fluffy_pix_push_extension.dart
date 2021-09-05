import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/push_subscription.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webcrypto/webcrypto.dart';
import 'fluffy_pix.dart';
import 'fluffy_pix_api_extension.dart';
import '../utils/convert_to_json.dart';
import 'push_credentials.dart';

extension FluffyPixPushExtension on FluffyPix {
  Future<void> initPush() async {
    await Firebase.initializeApp();
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

    final pushCredentials = loadCredentials();
    if (pushCredentials != null &&
        pushCredentials.endpoint == AppConfigs.pushGatewayUrl &&
        pushCredentials.token == token) {
      debugPrint('Push notifications already initialized!');
      return;
    }

    final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);

    final publicKey = const Base64Encoder().convert(
      await keyPair.publicKey.exportRawKey(),
    );
    final privateKey = const Base64Encoder().convert(
      await keyPair.privateKey.exportPkcs8Key(),
    );
    final bytes = Uint8List(16);
    fillRandomBytes(bytes);
    final auth = base64.encode(bytes);

    final platform = kIsWeb
        ? 'web'
        : Platform.isIOS
            ? 'ios'
            : Platform.isAndroid
                ? 'android'
                : 'unknown';

    final endpoint = '${AppConfigs.pushGatewayUrl}/$platform/$token';

    await setPushSubcription(
      endpoint.toString(),
      publicKey,
      auth,
      alerts: const PushSubscriptionAlerts(
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

  PushCredentials? loadCredentials() {
    final raw = box.get('pushCredentials');
    if (raw == null) return null;
    try {
      return PushCredentials.fromJson(
        (raw as Map).toJson(),
      );
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
