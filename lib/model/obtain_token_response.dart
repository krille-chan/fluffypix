class AccessTokenCredentials {
  final String accessToken;
  final String tokenType;
  final String? scope;
  final DateTime? createdAt;

  const AccessTokenCredentials({
    required this.accessToken,
    required this.tokenType,
    required this.scope,
    required this.createdAt,
  });

  AccessTokenCredentials.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        tokenType = json['token_type'],
        scope = json['scope'],
        createdAt = json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['created_at']);

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        if (scope != null) 'scope': scope,
        if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
      };
}
