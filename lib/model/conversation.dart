import 'package:fluffypix/model/status.dart';

import 'account.dart';

class Conversation {
  final String id;
  final bool unread;
  final List<Account> accounts;
  final Status? lastStatus;

  const Conversation({
    required this.id,
    required this.unread,
    required this.accounts,
    this.lastStatus,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'],
        unread: json['unread'],
        accounts:
            (json['accounts'] as List).map((i) => Account.fromJson(i)).toList(),
        lastStatus: json['last_status'] == null
            ? null
            : Status.fromJson(json['last_status']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'unread': unread,
        'accounts': accounts.map((i) => i.toJson()).toList(),
        if (lastStatus != null) 'last_status': lastStatus!.toJson(),
      };
}
