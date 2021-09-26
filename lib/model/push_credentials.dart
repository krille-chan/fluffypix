class PushCredentials {
  final String publickey;
  final String privatekey;
  final String auth;
  final String endpoint;

  const PushCredentials({
    required this.publickey,
    required this.privatekey,
    required this.auth,
    required this.endpoint,
  });

  factory PushCredentials.fromJson(Map<String, dynamic> json) =>
      PushCredentials(
        publickey: json['publickey'],
        privatekey: json['privatekey'],
        auth: json['auth'],
        endpoint: json['endpoint'],
      );

  Map<String, dynamic> toJson() => {
        'publickey': publickey,
        'privatekey': privatekey,
        'auth': auth,
        'endpoint': endpoint,
      };
}
