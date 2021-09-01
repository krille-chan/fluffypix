import 'field.dart';

class Account {
  final String id;
  final String username;
  final String acct;
  final String displayName;
  final bool locked;
  final bool bot;
  final bool? discoverable;
  final bool? group;
  final String createdAt;
  final String note;
  final String url;
  final String avatar;
  final String avatarStatic;
  final String header;
  final String headerStatic;
  final int? followersCount;
  final int followingCount;
  final int statusesCount;
  final String? lastStatusAt;
  final List<Object> emojis;
  final List<Field>? fields;

  const Account({
    required this.id,
    required this.username,
    required this.acct,
    required this.displayName,
    required this.locked,
    required this.bot,
    required this.discoverable,
    required this.group,
    required this.createdAt,
    required this.note,
    required this.url,
    required this.avatar,
    required this.avatarStatic,
    required this.header,
    required this.headerStatic,
    required this.followersCount,
    required this.followingCount,
    required this.statusesCount,
    required this.lastStatusAt,
    required this.emojis,
    required this.fields,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'],
        username: json['username'],
        acct: json['acct'],
        displayName: json['display_name'],
        locked: json['locked'],
        bot: json['bot'],
        discoverable: json['discoverable'],
        group: json['group'],
        createdAt: json['created_at'],
        note: json['note'],
        url: json['url'],
        avatar: json['avatar'],
        avatarStatic: json['avatar_static'],
        header: json['header'],
        headerStatic: json['header_static'],
        followersCount: json['followers_count'] is String
            ? int.parse(json['followers_count'])
            : json['followers_count'],
        followingCount: json['following_count'] is String
            ? int.parse(json['following_count'])
            : json['following_count'],
        statusesCount: json['statuses_count'],
        lastStatusAt: json['last_status_at'],
        emojis: List<Object>.from(json['emojis']),
        fields: json['fields'] == null
            ? null
            : (json['fields'] as List)
                .map((i) => Field.fromJson(Map<String, dynamic>.from(i)))
                .toList(),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'acct': acct,
        'display_name': displayName,
        'locked': locked,
        'bot': bot,
        if (discoverable != null) 'discoverable': discoverable,
        if (group != null) 'group': group,
        'created_at': createdAt,
        'note': note,
        'url': url,
        'avatar': avatar,
        'avatar_static': avatarStatic,
        'header': header,
        'header_static': headerStatic,
        if (followersCount != null) 'followers_count': followersCount,
        'following_count': followingCount,
        'statuses_count': statusesCount,
        if (lastStatusAt != null) 'last_status_at': lastStatusAt,
        'emojis': List<Object>.from(emojis),
        if (fields != null) 'fields': fields!.map((i) => i.toJson()).toList(),
      };
}
