class CreateApplicationResponse {
  final String id;
  final String name;
  final String? website;
  final String redirectUri;
  final String clientId;
  final String clientSecret;
  final String? vapidKey;

  CreateApplicationResponse({
    required this.id,
    required this.name,
    this.website,
    required this.redirectUri,
    required this.clientId,
    required this.clientSecret,
    required this.vapidKey,
  });

  CreateApplicationResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        website = json['website'],
        redirectUri = json['redirect_uri'],
        clientId = json['client_id'].toString(),
        clientSecret = json['client_secret'],
        vapidKey = json['vapid_key']?.toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'website': website,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'client_secret': clientSecret,
        'vapid_key': vapidKey,
      };
}
