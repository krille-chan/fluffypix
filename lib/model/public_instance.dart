class PublicInstance {
  final String id;
  final String name;
  final DateTime? addedAt;
  final DateTime? updatedAt;
  final DateTime? checkedAt;
  final int? uptime;
  final bool? dead;
  final String? version;
  final String? users;
  final String? statuses;
  final String? connections;
  final bool? openRegistrations;
  final String? thumbnail;
  final String? email;
  final String? admin;
  final String? shortDescription;
  final String? fullDescription;

  PublicInstance.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        addedAt =
            json['added_at'] != null ? DateTime.parse(json['added_at']) : null,
        updatedAt = json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        checkedAt = json['checked_at'] != null
            ? DateTime.parse(json['checked_at'])
            : null,
        uptime = json['uptime'],
        dead = json['dead'],
        version = json['version'],
        users = json['users'],
        statuses = json['statuses'],
        connections = json['connections'],
        openRegistrations = json['open_registrations'],
        thumbnail = json['thumbnail'],
        email = json['email'],
        admin = json['admin'],
        shortDescription =
            json['info'] != null ? json['info']['short_description'] : null,
        fullDescription =
            json['info'] != null ? json['info']['long_description'] : null;
}
