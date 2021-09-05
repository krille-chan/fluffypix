class ReadMarkers {
  final ReadMarker? notifications;
  final ReadMarker? home;

  const ReadMarkers({
    this.notifications,
    this.home,
  });

  factory ReadMarkers.fromJson(Map<String, dynamic> json) => ReadMarkers(
        notifications: json['notifications'] == null
            ? null
            : ReadMarker.fromJson(json['notifications']),
        home: json['home'] == null ? null : ReadMarker.fromJson(json['home']),
      );

  Map<String, dynamic> toJson() => {
        if (notifications != null) 'notifications': notifications!.toJson(),
        if (home != null) 'home': home!.toJson(),
      };
}

class ReadMarker {
  final String lastReadId;
  final int? version;
  final String? updatedAt;

  const ReadMarker({
    required this.lastReadId,
    this.version,
    this.updatedAt,
  });

  factory ReadMarker.fromJson(Map<String, dynamic> json) => ReadMarker(
        lastReadId: json['last_read_id'],
        version: json['version'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'last_read_id': lastReadId,
        if (version != null) 'version': version,
        if (updatedAt != null) 'updated_at': updatedAt,
      };
}
