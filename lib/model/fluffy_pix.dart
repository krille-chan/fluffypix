import 'dart:async';
import 'dart:convert';

import 'package:fluffypix/config/app_configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import '../utils/convert_to_json.dart';
import 'account.dart';
import 'obtain_token_response.dart';
import 'status.dart';
import 'notification.dart';
import 'fluffy_pix_websocket_extension.dart';

enum RequestType { get, post, put, delete }

class FluffyPix {
  final Client _client;
  late final Box _box;
  Box get box => _box;
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
    if (isLogged) subscribeToWebsocket();
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

  Future<void> save() => _box.put(AppConfigs.hiveBoxAccountKey, toJson());

  Future<Map<String, dynamic>> request(
    RequestType type,
    String action, {
    dynamic data = '',
    int? timeout,
    String contentType = 'application/json',
    String? contentLength,
    Map<String, dynamic>? query,
  }) async {
    if (this.instance == null) {
      throw ('No instance specified.');
    }
    final instance = this.instance!;
    dynamic json;
    (data is! String) ? json = jsonEncode(data) : json = data;
    if (data is List<int> || action.startsWith('/api/v1/media')) json = data;

    final url = instance.resolveUri(Uri(
      path: action,
      queryParameters: query,
    ));

    final headers = <String, String>{};
    if (type == RequestType.put || type == RequestType.post) {
      headers['Content-Type'] = contentType;
      if (contentLength != null) {
        headers['Content-Length'] = contentLength;
      }
    }
    final accessToken = accessTokenCredentials?.accessToken;
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

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
      final linkHeader = resp.headers['link'];
      String? next;
      String? prev;
      if (linkHeader != null) {
        final linkHeaderParts = linkHeader.split(',');
        for (final part in linkHeaderParts) {
          if (part.endsWith('rel="next"')) {
            next = Uri.parse(part.split('<').last.split('>').first)
                .queryParameters['max_id'];
          } else if (part.endsWith('rel="prev"')) {
            prev = Uri.parse(part.split('<').last.split('>').first)
                .queryParameters['max_id'];
          }
        }
      }
      jsonString = '{"chunk":$jsonString,"next":$next,"prev":$prev}';
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

  Future<void> storeCachedTimeline<T>(String key, List<T> timeline,
          Map<String, dynamic> Function(T) toJson) =>
      _box.put(key, timeline.map((t) => toJson(t)).toList());

  List<T>? getCachedTimeline<T>(
    String key,
    T Function(Map<String, dynamic>) parser,
  ) {
    final raw = _box.get(key);
    if (raw == null || raw is! List) return null;
    return raw.map((json) => parser((json as Map).toJson())).toList();
  }

  bool get allowAnimatedAvatars => _box.get('allowAnimatedAvatars') ?? true;
  set allowAnimatedAvatars(bool b) => _box.put('allowAnimatedAvatars', b);

  bool get displayThumbnailsOnly => _box.get('displayThumbnailsOnly') ?? false;
  set displayThumbnailsOnly(bool b) => _box.put('displayThumbnailsOnly', b);

  bool get useInAppBrowser => _box.get('useInAppBrowser') ?? true;
  set useInAppBrowser(bool b) => _box.put('useInAppBrowser', b);

  bool get usePublicTimeline => _box.get('usePublicTimeline') ?? true;
  set usePublicTimeline(bool b) => _box.put('usePublicTimeline', b);

  bool get useDiscoverGridView => _box.get('useDiscoverGridView') ?? true;
  set useDiscoverGridView(bool b) => _box.put('useDiscoverGridView', b);

  StreamSubscription? onUpdateSub;
  IOWebSocketChannel? channel;

  final StreamController<Status> onHomeTimelineUpdate =
      StreamController.broadcast();
  final StreamController<PushNotification> onNotificationUpdate =
      StreamController.broadcast();
  final StreamController<String> onDeleteStatusUpdate =
      StreamController.broadcast();
  final StreamController<void> onChangeFilterUpdate =
      StreamController.broadcast();
}
