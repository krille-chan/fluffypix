class StreamUpdate {
  final List<String>? stream;
  final StreamUpdateEvent event;
  final dynamic payload;

  const StreamUpdate({
    required this.stream,
    required this.event,
    required this.payload,
  });

  factory StreamUpdate.fromJson(Map<String, dynamic> json) => StreamUpdate(
        stream:
            json['stream'] == null ? null : List<String>.from(json['stream']),
        event: StreamUpdateEvent.values
            .firstWhere((t) => t.toString().split('.').last == json['event']),
        payload: json['payload'],
      );

  Map<String, dynamic> toJson() => {
        if (stream != null) 'stream': List<String>.from(stream!),
        'event': event.toString().split('.').last,
        'payload': payload,
      };
}

// ignore: constant_identifier_names
enum StreamUpdateEvent { update, notification, delete, filters_changed }
