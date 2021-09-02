import 'package:fluffypix/model/status.dart';

import 'account.dart';

enum NotificationType {
  mention,
  favourite,
  follow,
  // ignore: constant_identifier_names
  follow_request,
  reblog,
  poll,
  status
}

class PushNotification {
  final String id;
  final NotificationType type;
  final DateTime createdAt;
  final Account account;
  final Status? status;

  const PushNotification({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.account,
    this.status,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      PushNotification(
        id: json['id'],
        type: NotificationType.values
            .firstWhere((n) => n.toString().split('.').last == json['type']),
        createdAt: DateTime.parse(json['created_at']),
        account: Account.fromJson(json['account']),
        status: json['status'] != null ? Status.fromJson(json['status']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString().split('.').last,
        'created_at': createdAt.toIso8601String(),
        'account': account.toJson(),
        if (status != null) 'status': status!.toJson(),
      };
}
