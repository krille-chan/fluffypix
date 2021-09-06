import 'package:fluffypix/model/search_result.dart';
import 'package:fluffypix/model/status_visibility.dart';
import 'account.dart';
import 'application.dart';
import 'card.dart';
import 'media_attachment.dart';

class Status {
  final String id;
  final DateTime createdAt;
  final String? inReplyToId;
  final String? inReplyToAccountId;
  final bool sensitive;
  final String spoilerText;
  final StatusVisibility visibility;
  final String? language;
  final String uri;
  final String? url;
  final int repliesCount;
  final int reblogsCount;
  final int favouritesCount;
  final bool? favourited;
  final bool? reblogged;
  final bool? muted;
  final bool? bookmarked;
  final String? content;
  final Status? reblog;
  final Application? application;
  final Account account;
  final List<MediaAttachment> mediaAttachments;
  final List<Mention> mentions;
  final List<Hashtag> tags;
  final List<Emoji> emojis;
  final Card? card;
  final Map? poll;

  const Status({
    required this.id,
    required this.createdAt,
    this.inReplyToId,
    this.inReplyToAccountId,
    required this.sensitive,
    required this.spoilerText,
    required this.visibility,
    required this.language,
    required this.uri,
    required this.url,
    required this.repliesCount,
    required this.reblogsCount,
    required this.favouritesCount,
    this.favourited,
    this.reblogged,
    this.muted,
    this.bookmarked,
    this.content,
    required this.reblog,
    required this.application,
    required this.account,
    required this.mediaAttachments,
    required this.mentions,
    required this.tags,
    required this.emojis,
    required this.card,
    this.poll,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        inReplyToId: json['in_reply_to_id'],
        inReplyToAccountId: json['in_reply_to_account_id'],
        sensitive: json['sensitive'],
        spoilerText: json['spoiler_text'],
        visibility: StatusVisibility.values.firstWhere(
            (v) => v.toString().split('.').last == json['visibility']),
        language: json['language'],
        uri: json['uri'],
        url: json['url'],
        repliesCount: json['replies_count'] ?? 0,
        reblogsCount: json['reblogs_count'] ?? 0,
        favouritesCount: json['favourites_count'] ?? 0,
        favourited: json['favourited'],
        reblogged: json['reblogged'],
        muted: json['muted'],
        bookmarked: json['bookmarked'],
        content: json['content'],
        reblog: json['reblog'] != null ? Status.fromJson(json['reblog']) : null,
        application: json['application'] == null
            ? null
            : Application.fromJson(json['application']),
        account: Account.fromJson(json['account']),
        mediaAttachments:
            List<Map<String, dynamic>>.from(json['media_attachments'])
                .map((json) => MediaAttachment.fromJson(json))
                .toList(),
        mentions: List<Map<String, dynamic>>.from(json['mentions'])
            .map((json) => Mention.fromJson(json))
            .toList(),
        tags: List<Map<String, dynamic>>.from(json['tags'])
            .map((json) => Hashtag.fromJson(json))
            .toList(),
        emojis: List<Map<String, dynamic>>.from(json['emojis'])
            .map((json) => Emoji.fromJson(json))
            .toList(),
        card: json['card'] == null ? null : Card.fromJson(json['card']),
        poll: json['poll'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        if (inReplyToId != null) 'in_reply_to_id': inReplyToId,
        if (inReplyToAccountId != null)
          'in_reply_to_account_id': inReplyToAccountId,
        'sensitive': sensitive,
        'spoiler_text': spoilerText,
        'visibility': visibility.toString().split('.').last,
        if (language != null) 'language': language,
        'uri': uri,
        if (url != null) 'url': url,
        'replies_count': repliesCount,
        'reblogs_count': reblogsCount,
        'favourites_count': favouritesCount,
        'favourited': favourited,
        'reblogged': reblogged,
        'muted': muted,
        'bookmarked': bookmarked,
        'content': content,
        if (reblog != null) 'reblog': reblog!.toJson(),
        if (application != null) 'application': application!.toJson(),
        'account': account.toJson(),
        'media_attachments': mediaAttachments.map((m) => m.toJson()).toList(),
        'mentions': mentions.map((m) => m.toJson()).toList(),
        'tags': tags.map((m) => m.toJson()).toList(),
        'emojis': emojis.map((m) => m.toJson()).toList(),
        if (card != null) 'card': card!.toJson(),
        if (poll != null) 'poll': poll,
      };
}

class Mention {
  final String id;
  final String username;
  final String url;
  final String acct;

  const Mention({
    required this.id,
    required this.username,
    required this.url,
    required this.acct,
  });

  factory Mention.fromJson(Map<String, dynamic> json) => Mention(
        id: json['id'],
        username: json['username'],
        url: json['url'],
        acct: json['acct'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'url': url,
        'acct': acct,
      };
}

class Emoji {
  final String shortcode;
  final String url;
  final String staticUrl;
  final bool visibleInPicker;
  final String? category;

  const Emoji({
    required this.shortcode,
    required this.url,
    required this.staticUrl,
    required this.visibleInPicker,
    this.category,
  });

  factory Emoji.fromJson(Map<String, dynamic> json) => Emoji(
        shortcode: json['shortcode'],
        url: json['url'],
        staticUrl: json['static_url'],
        visibleInPicker: json['visible_in_picker'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'shortcode': shortcode,
        'url': url,
        'static_url': staticUrl,
        'visible_in_picker': visibleInPicker,
        if (category != null) 'category': category,
      };
}
