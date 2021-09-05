class PushSubscription {
  final int id;
  final String endpoint;
  final PushSubscriptionAlerts alerts;
  final String serverKey;

  const PushSubscription({
    required this.id,
    required this.endpoint,
    required this.alerts,
    required this.serverKey,
  });

  factory PushSubscription.fromJson(Map<String, dynamic> json) =>
      PushSubscription(
        id: json['id'],
        endpoint: json['endpoint'],
        alerts: PushSubscriptionAlerts.fromJson(json['alerts']),
        serverKey: json['server_key'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'alerts': alerts.toJson(),
        'server_key': serverKey,
      };
}

class PushSubscriptionAlerts {
  bool? follow;
  bool? favourite;
  bool? reblog;
  bool? mention;
  bool? poll;

  PushSubscriptionAlerts({
    this.follow,
    this.favourite,
    this.reblog,
    this.mention,
    this.poll,
  });

  factory PushSubscriptionAlerts.fromJson(Map<String, dynamic> json) =>
      PushSubscriptionAlerts(
        follow: json['follow'],
        favourite: json['favourite'],
        reblog: json['reblog'],
        mention: json['mention'],
        poll: json['poll'],
      );

  Map<String, dynamic> toJson() => {
        if (follow != null) 'follow': follow,
        if (favourite != null) 'favourite': favourite,
        if (reblog != null) 'reblog': reblog,
        if (mention != null) 'mention': mention,
        if (poll != null) 'poll': poll,
      };
}
