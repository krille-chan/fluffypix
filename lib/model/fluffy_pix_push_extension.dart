import 'dart:developer';

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluffypix/config/app_configs.dart';
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

    final pushCredentials = loadCredentials();
    if (pushCredentials != null &&
        pushCredentials.endpoint == AppConfigs.pushGatewayUrl &&
        pushCredentials.token == token) {
      log('Push notifications already initialized!');
    }

    final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);

    final publicKey = const Base64Encoder().convert(
      await keyPair.publicKey.exportRawKey(),
    );
    final privateKey = const Base64Encoder().convert(
      await keyPair.privateKey.exportPkcs8Key(),
    );
    await setPushSubcription(
      AppConfigs.pushGatewayUrl,
      publicKey,
      token,
    );

    await _saveCredentials(PushCredentials(
      token: token,
      publickey: publicKey,
      privatekey: privateKey,
      endpoint: AppConfigs.pushGatewayUrl,
    ));
    log('Push notifications initialized!');
  }

  PushCredentials? loadCredentials() {
    final raw = box.get('pushCredentials');
    return raw == null
        ? null
        : PushCredentials.fromJson(
            (raw as Map).toJson(),
          );
  }

  Future<void> _saveCredentials(PushCredentials credentials) => box.put(
        'pushCredentials',
        credentials.toJson(),
      );
}
