import 'dart:convert';
import 'dart:io';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/instances_api_token.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:webcrypto/webcrypto.dart';

import 'create_application_response.dart';
import 'fluffy_pix.dart';
import 'public_instance.dart';
import 'fluffy_pix_api_extension.dart';
import 'fluffy_pix_push_extension.dart';
import '../utils/convert_to_json.dart';

extension FluffyPixLoginExtension on FluffyPix {
  String get _redirectUri => !kIsWeb && (Platform.isAndroid || Platform.isIOS)
      ? AppConfigs.loginRedirectUri
      : _noRedirectUri;

  static const String _noRedirectUri = 'urn:ietf:wg:oauth:2.0:oob';

  bool get automaticRedirectUriAvailable => _redirectUri != _noRedirectUri;

  Uri getOAuthUri(
    String domain,
    String clientId,
  ) =>
      Uri.https(domain, '/oauth/authorize', {
        'client_id': clientId,
        'redirect_uri': _redirectUri,
        'response_type': 'code',
        'scope': 'read write follow push',
      });

  static const Set<String> ipv6 = {
    'E8BD7AFB2125B7EA5E1B885FAC2A657D817EEC289ED870AA3D1D0ACBE6ADED8F',
  };

  static const String _defaultSearchLanguage = 'en';

  Future<CreateApplicationResponse> connectToInstance(
      String domain, void Function(Uri) launch) async {
    instance = Uri.https(domain, '/');
    debugPrint('Create Application on $instance...');
    if (!kDebugMode &&
        ipv6.contains(
          String.fromCharCodes(
            await Hash.sha256.digestBytes(
              utf8.encode(
                instance.toString(),
              ),
            ),
          ),
        )) {
      throw const SocketException('Server is not compatible with IPv6');
    }
    final createApplicationResponse = await createApplication(
      AppConfigs.applicationName,
      _redirectUri,
      scopes: 'read write follow push',
      website: AppConfigs.applicationWebsite,
    );
    final oAuthUri = getOAuthUri(
      domain,
      createApplicationResponse.clientId,
    );
    debugPrint('Open OAuth Uri $oAuthUri...');
    launch(oAuthUri);
    box.put('createApplicationResponse', createApplicationResponse.toJson());

    return createApplicationResponse;
  }

  Future<void> login(
    String code,
    CreateApplicationResponse createApplicationResponse,
  ) async {
    if (instance == null) throw Exception('Connect to instance first!');
    try {
      accessTokenCredentials = await obtainToken(
        createApplicationResponse.clientId,
        createApplicationResponse.clientSecret,
        _redirectUri,
        code: code,
        grantType: 'authorization_code',
        scope: 'read write follow push',
      );
      ownAccount = await verifyAccountCredentials();
      initPush();
      return save();
    } catch (_) {
      await logout(revoke: false);
      rethrow;
    }
  }

  Future<void> logout({bool revoke = true}) async {
    try {
      final createApplicationResponse = CreateApplicationResponse.fromJson(
        (box.get('createApplicationResponse') as Map).toJson(),
      );
      if (revoke) {
        await revokeToken(
          createApplicationResponse.clientId,
          createApplicationResponse.clientSecret,
          accessTokenCredentials!.accessToken,
        );
      }
    } finally {
      accessTokenCredentials = instance = ownAccount = null;
      await box.deleteAll(box.keys);
    }
  }

  Future<List<PublicInstance>> requestInstances(String language,
      [String? query]) async {
    if (query?.isEmpty ?? false) query = null;
    final url = Uri.https(
      'instances.social',
      '/api/1.0/instances/${query == null ? 'list' : 'search'}',
      query != null
          ? {'q': query}
          : {
              'language': language,
              'prohibited_content': 'nudity_all',
              'sort_by': 'active_users',
              'sort_order': 'desc',
            },
    );
    final response = await get(
      url,
      headers: {'Authorization': 'Bearer ${InstancesApiToken.token}'},
    );
    if (response.statusCode != 200) throw Exception(response.reasonPhrase);
    final responseJson = jsonDecode(response.body);
    final instances = (responseJson['instances'] as List)
        .map((json) => PublicInstance.fromJson(json))
        .toList();
    if (query == null &&
        instances.isEmpty &&
        language != _defaultSearchLanguage) {
      return requestInstances(_defaultSearchLanguage);
    }
    if (query == null) {
      instances.removeWhere((i) => i.openRegistrations != true);
    }
    return instances;
  }
}
