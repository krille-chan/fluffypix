import 'package:fluffypix/model/push_subscription.dart';
import 'package:fluffypix/model/read_markers.dart';

import 'account.dart';
import 'chunk.dart';
import 'conversation.dart';
import 'create_application_response.dart';
import 'fluffy_pix.dart';
import 'notification.dart';
import 'obtain_token_response.dart';
import 'relationships.dart';
import 'search_result.dart';
import 'status.dart';
import 'status_context.dart';
import 'status_visibility.dart';

extension FluffyPixApiExtension on FluffyPix {
  Future<Account> verifyAccountCredentials() => request(
        RequestType.get,
        '/api/v1/accounts/verify_credentials',
      ).then((json) => Account.fromJson(json));

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

  Future<List<Status>> requestPublicTimeline({
    String? maxId,
    bool mediaOnly = true,
    bool local = false,
  }) =>
      request(RequestType.get, '/api/v1/timelines/public', query: {
        if (maxId != null) 'max_id': maxId,
        'only_media': mediaOnly.toString(),
        'limit': '30',
        'local': local.toString(),
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

  Future<List<Status>> requestUserTimeline(
    String userId, {
    String? maxId,
    bool excludeReplies = true,
    bool onlyMedia = true,
  }) =>
      request(RequestType.get,
          '/api/v1/accounts/${Uri.encodeComponent(userId)}/statuses',
          query: {
            if (maxId != null) 'max_id': maxId,
            'exclude_replies': excludeReplies.toString(),
            'only_media': onlyMedia.toString(),
            'limit': '21',
          }).then(
        (json) =>
            (json['chunk'] as List).map((j) => Status.fromJson(j)).toList(),
      );

  Future<Chunk<PushNotification>> getNotifications({
    String? maxId,
    String? sinceId,
    String? limit,
  }) =>
      request(RequestType.get, '/api/v1/notifications', query: {
        if (maxId != null) 'max_id': maxId,
        if (sinceId != null) 'since_id': sinceId,
        if (limit != null) 'limit': limit,
      }).then(
        (json) => Chunk.fromJson(json, (m) => PushNotification.fromJson(m)),
      );

  Future<List<Conversation>> requestConversations({String? maxId}) =>
      request(RequestType.get, '/api/v1/conversations', query: {
        if (maxId != null) 'max_id': maxId,
      }).then(
        (json) => (json['chunk'] as List)
            .map((j) => Conversation.fromJson(j))
            .toList(),
      );

  Future<Chunk<Account>> requestFollowers(String id, {String? maxId}) =>
      request(RequestType.get,
          '/api/v1/accounts/${Uri.encodeComponent(id)}/followers',
          query: {
            if (maxId != null) 'max_id': maxId,
          }).then(
        (json) => Chunk.fromJson(json, (m) => Account.fromJson(m)),
      );

  Future<Chunk<Account>> requestFollowing(String id, {String? maxId}) =>
      request(RequestType.get,
          '/api/v1/accounts/${Uri.encodeComponent(id)}/following',
          query: {
            if (maxId != null) 'max_id': maxId,
          }).then(
        (json) => Chunk.fromJson(json, (m) => Account.fromJson(m)),
      );

  Future<Status> getStatus(String id) => request(
        RequestType.get,
        '/api/v1/statuses/${Uri.encodeComponent(id)}',
      ).then(
        (json) => Status.fromJson(json),
      );

  Future<StatusContext> getStatusContext(String id) => request(
        RequestType.get,
        '/api/v1/statuses/${Uri.encodeComponent(id)}/context',
      ).then(
        (json) => StatusContext.fromJson(json),
      );

  Future<Account> loadAccount(String username) => request(
        RequestType.get,
        '/api/v1/accounts/${Uri.encodeComponent(username)}',
      ).then(
        (json) => Account.fromJson(json),
      );

  Future<Relationships> getRelationship(String username) => request(
        RequestType.get,
        '/api/v1/accounts/relationships',
        query: {'id': username},
      ).then(
        (json) => Relationships.fromJson(json['chunk'].single),
      );

  Future<void> report(
    String accountId,
    List<String> statusIds,
    String comment,
  ) =>
      request(RequestType.post, '/api/v1/report', data: {
        'account_id': accountId,
        'status_ids': statusIds,
        'comment': comment,
        'forward': true,
      });

  Future<SearchResult> search(String query, {String? maxId}) =>
      request(RequestType.get, '/api/v2/search', query: {
        'q': query,
        if (maxId != null) 'max_id': maxId,
      }).then(
        (json) => SearchResult.fromJson(json),
      );

  Future<List<Hashtag>> getTrends({int limit = 10}) =>
      request(RequestType.get, '/api/v1/trends',
          query: {'limit': limit.toString()}).then(
        (json) =>
            (json['chunk'] as List).map((j) => Hashtag.fromJson(j)).toList(),
      );

  Future<List<Account>> getTrendAccounts({int limit = 10}) =>
      request(RequestType.get, '/api/v1/directory',
          query: {'limit': limit.toString()}).then(
        (json) =>
            (json['chunk'] as List).map((j) => Account.fromJson(j)).toList(),
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

  Future<void> revokeToken(
    String clientId,
    String clientSecret,
    String token,
  ) =>
      request(RequestType.post, '/oauth/revoke', data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'token': token,
      });

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

  Future<Relationships> follow(String id) => request(
        RequestType.post,
        '/api/v1/accounts/${Uri.encodeComponent(id)}/follow',
      ).then((json) => Relationships.fromJson(json));

  Future<Relationships> unfollow(String id) => request(
        RequestType.post,
        '/api/v1/accounts/${Uri.encodeComponent(id)}/unfollow',
      ).then((json) => Relationships.fromJson(json));

  Future<Relationships> mute(String id) => request(
        RequestType.post,
        '/api/v1/accounts/${Uri.encodeComponent(id)}/mute',
      ).then((json) => Relationships.fromJson(json));

  Future<Relationships> unmute(String id) => request(
        RequestType.post,
        '/api/v1/accounts/${Uri.encodeComponent(id)}/unmute',
      ).then((json) => Relationships.fromJson(json));

  Future<Relationships> block(String id) => request(
        RequestType.post,
        '/api/v1/accounts/${Uri.encodeComponent(id)}/block',
      ).then((json) => Relationships.fromJson(json));

  Future<Relationships> unblock(String id) => request(
        RequestType.post,
        '/api/v1/accounts/${Uri.encodeComponent(id)}/unblock',
      ).then((json) => Relationships.fromJson(json));

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

  Future<PushSubscription?> getCurrentPushSubscription() => request(
        RequestType.get,
        '/api/v1/push/subscription',
      ).then((json) => json['error'] == 'Record not found'
          ? null
          : PushSubscription.fromJson(json));

  Future<PushSubscription> setPushSubcription(
          String endpoint, String publicKey, String pushToken,
          {PushSubscriptionAlerts? alerts}) =>
      request(
        RequestType.post,
        '/api/v1/push/subscription',
        data: {
          'subscription': {
            'endpoint': endpoint,
            'keys': {
              'p256dh': publicKey,
              'auth': pushToken,
            },
          },
          if (alerts != null) 'data': {'alerts': alerts.toJson()},
        },
      ).then((json) => PushSubscription.fromJson(json));

  Future<PushSubscription> setPushsubcriptionAlerts(
          PushSubscriptionAlerts alerts) =>
      request(
        RequestType.put,
        '/api/v1/push/subscription',
        data: {
          'data': {'alerts': alerts.toJson()}
        },
      ).then((json) => PushSubscription.fromJson(json));

  Future<ReadMarkers> getMarkers(String timeline) =>
      request(RequestType.get, '/api/v1/markers', query: {
        'timeline': 'notifications',
      }).then((json) => ReadMarkers.fromJson(json));

  Future<ReadMarkers> setMarkers(ReadMarkers readMarkers) => request(
        RequestType.post,
        '/api/v1/markers',
        data: readMarkers.toJson(),
      ).then((json) => ReadMarkers.fromJson(json));
}
