import 'dart:convert';
import 'dart:io';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/instances_api_token.dart';
import 'package:fluffypix/model/status_visibility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'account.dart';
import 'conversation.dart';
import 'create_application_response.dart';
import 'obtain_token_response.dart';
import 'public_instance.dart';
import 'status.dart';

enum RequestType { get, post, put, delete }

class FluffyPix {
  final Client _client;
  late final Box _box;
  late final Future<void> initialized;

  Uri? instance;
  AccessTokenCredentials? accessTokenCredentials;
  Account? ownAccount;

  bool get isLogged => accessTokenCredentials != null && instance != null;

  FluffyPix({
    Client? httpClient,
    Box? box,
  }) : _client = httpClient ?? Client() {
    initialized = _init();
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(AppConfigs.hiveBoxName);
    final json = _box.get(AppConfigs.hiveBoxAccountKey);
    if (json != null) _loadFromJson(Map<String, dynamic>.from(json));
    return;
  }

  factory FluffyPix.of(BuildContext context) =>
      Provider.of<FluffyPix>(context, listen: false);

  void _loadFromJson(Map<String, dynamic> json) {
    accessTokenCredentials = json['access_token_credentials'] != null
        ? AccessTokenCredentials.fromJson(
            Map<String, dynamic>.from(json['access_token_credentials']))
        : null;
    ownAccount = json['own_account'] != null
        ? Account.fromJson(Map<String, dynamic>.from(json['own_account']))
        : null;
    instance =
        json.containsKey('instance') ? Uri.parse(json['instance']) : null;
  }

  Widget builder(BuildContext context, Widget? child) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
        ),
      );
    });
    return Provider(create: (_) => this, child: child ?? Container());
  }

  Map<String, dynamic> toJson() => {
        'access_token_credentials': accessTokenCredentials?.toJson(),
        'own_account': ownAccount?.toJson(),
        'instance': instance?.toString(),
      };

  Future<void> _save() => _box.put(AppConfigs.hiveBoxAccountKey, toJson());

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

  Future<CreateApplicationResponse> connectToInstance(
      String domain, void Function(Uri) launch) async {
    instance = Uri.https(domain, '/');
    debugPrint('Create Application on $instance...');
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
    } catch (_) {
      await logout();
      rethrow;
    }
    return _save();
  }

  Future<void> logout() async {
    accessTokenCredentials = instance = ownAccount = null;
    return _box.delete(AppConfigs.hiveBoxAccountKey);
  }

  Future<Account> verifyAccountCredentials() => request(
        RequestType.get,
        '/api/v1/accounts/verify_credentials',
      ).then((json) => Account.fromJson(json));

  Future<Map<String, dynamic>> request(
    RequestType type,
    String action, {
    dynamic data = '',
    int? timeout,
    String contentType = 'application/json',
    Map<String, dynamic>? query,
  }) async {
    if (this.instance == null) {
      throw ('No instance specified.');
    }
    final instance = this.instance!;
    dynamic json;
    (data is! String) ? json = jsonEncode(data) : json = data;
    if (data is List<int> || action.startsWith('/media/r0/upload')) json = data;

    final url = instance.resolveUri(Uri(
      path: action,
      queryParameters: query,
    ));

    final headers = <String, String>{};
    if (type == RequestType.put || type == RequestType.post) {
      headers['Content-Type'] = contentType;
    }
    final accessToken = accessTokenCredentials?.accessToken;
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    //print('${type.toString()} ${url.toString()} $json');

    Response resp;
    var jsonResp = <String, dynamic>{};
    switch (type) {
      case RequestType.get:
        resp = await _client.get(url, headers: headers).timeout(
              AppConfigs.defaultTimeout,
            );
        break;
      case RequestType.post:
        resp = await _client.post(url, body: json, headers: headers).timeout(
              AppConfigs.defaultTimeout,
            );
        break;
      case RequestType.put:
        resp = await _client.put(url, body: json, headers: headers).timeout(
              AppConfigs.defaultTimeout,
            );
        break;
      case RequestType.delete:
        resp = await _client.delete(url, headers: headers).timeout(
              AppConfigs.defaultTimeout,
            );
        break;
    }
    var respBody = resp.body;
    try {
      respBody = utf8.decode(resp.bodyBytes);
    } catch (_) {
      // No-OP
    }
    if (resp.statusCode >= 500 && resp.statusCode < 600) {
      throw Exception(respBody);
    }
    var jsonString = String.fromCharCodes(respBody.runes);
    if (jsonString.startsWith('[') && jsonString.endsWith(']')) {
      jsonString = '{"chunk":$jsonString}';
    }
    jsonResp = jsonDecode(jsonString)
        as Map<String, dynamic>; // May throw FormatException
    if (resp.statusCode >= 400 && resp.statusCode < 500) {
      throw Exception(jsonResp['error_description'] ??
          jsonResp['error'] ??
          resp.reasonPhrase);
    }

    return jsonResp;
  }

  static const String _defaultSearchLanguage = 'en';

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

  Future<CreateApplicationResponse> createApplication(
    String clientName,
    String redirectUris, {
    String? scopes,
    String? website,
  }) =>
      request(RequestType.post, '/api/v1/apps', data: {
        'client_name': clientName,
        'redirect_uris': redirectUris,
        if (scopes != null) 'scopes': scopes,
        if (website != null) 'website': website,
      }).then((json) => CreateApplicationResponse.fromJson(json));

  Future<List<Status>> requestHomeTimeline({String? maxId}) =>
      request(RequestType.get, '/api/v1/timelines/home', query: {
        if (maxId != null) 'max_id': maxId,
      }).then(
        (json) =>
            (json['chunk'] as List).map((j) => Status.fromJson(j)).toList(),
      );

  Future<List<Status>> requestPublicTimeline({String? maxId}) =>
      request(RequestType.get, '/api/v1/timelines/public', query: {
        if (maxId != null) 'max_id': maxId,
        'only_media': 'true',
        'limit': '30',
      }).then(
        (json) =>
            (json['chunk'] as List).map((j) => Status.fromJson(j)).toList(),
      );

  Future<List<Status>> requestTagTimeline(String tag, {String? maxId}) =>
      request(
          RequestType.get, '/api/v1/timelines/tag/${Uri.encodeComponent(tag)}',
          query: {
            if (maxId != null) 'max_id': maxId,
          }).then(
        (json) =>
            (json['chunk'] as List).map((j) => Status.fromJson(j)).toList(),
      );

  Future<List<Conversation>> requestConversations({String? maxId}) =>
      request(RequestType.get, '/api/v1/conversations', query: {
        if (maxId != null) 'max_id': maxId,
      }).then(
        (json) => (json['chunk'] as List)
            .map((j) => Conversation.fromJson(j))
            .toList(),
      );

  Future<AccessTokenCredentials> obtainToken(
    String clientId,
    String clientSecret,
    String redirectUri, {
    String? scope,
    String? code,
    String? grantType,
  }) =>
      request(RequestType.post, '/oauth/token', data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
        if (scope != null) 'scope': scope,
        if (code != null) 'code': code,
        if (grantType != null) 'grant_type': grantType,
      }).then(
        (json) => AccessTokenCredentials.fromJson(json),
      );

  Future<Status> favoriteStatus(String statusId) => request(
        RequestType.post,
        '/api/v1/statuses/${Uri.encodeComponent(statusId)}/favourite',
      ).then((json) => Status.fromJson(json));

  Future<Status> unfavoriteStatus(String statusId) => request(
        RequestType.post,
        '/api/v1/statuses/${Uri.encodeComponent(statusId)}/unfavourite',
      ).then((json) => Status.fromJson(json));

  Future<Status> boostStatus(String statusId) => request(
        RequestType.post,
        '/api/v1/statuses/${Uri.encodeComponent(statusId)}/reblog',
      ).then((json) => Status.fromJson(json));

  Future<Status> unboostStatus(String statusId) => request(
        RequestType.post,
        '/api/v1/statuses/${Uri.encodeComponent(statusId)}/unreblog',
      ).then((json) => Status.fromJson(json));

  Future<Status> publishNewStatus({
    String? status,
    List<String>? mediaIds,
    String? inReplyTo,
    bool? sensitive,
    StatusVisibility? visibility,
  }) =>
      request(
        RequestType.post,
        '/api/v1/statuses',
        data: {
          if (status != null) 'status': status,
          if (mediaIds != null) 'media_ids': mediaIds,
          if (inReplyTo != null) 'in_reply_to_id': inReplyTo,
          if (sensitive != null) 'sensitive': sensitive,
          if (visibility != null)
            'visibility': visibility.toString().split('.').last,
        },
      ).then((json) => Status.fromJson(json));

  Future<void> deleteStatus(
    String statusId,
  ) =>
      request(
        RequestType.delete,
        '/api/v1/statuses/${Uri.encodeComponent(statusId)}',
      ).then((json) => Status.fromJson(json));
}
