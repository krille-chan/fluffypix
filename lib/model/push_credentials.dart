class PushCredentials {
  final String token;
  final String publickey;
  final String privatekey;
  final String auth;
  final String endpoint;

  const PushCredentials({
    required this.token,
    required this.publickey,
    required this.privatekey,
    required this.auth,
    required this.endpoint,
  });

  factory PushCredentials.fromJson(Map<String, dynamic> json) =>
      PushCredentials(
        token: json['token'],
        publickey: json['publickey'],
        privatekey: json['privatekey'],
        auth: json['auth'],
        endpoint: json['endpoint'],
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'publickey': publickey,
        'privatekey': privatekey,
        'auth': auth,
        'endpoint': endpoint,
      };
}
