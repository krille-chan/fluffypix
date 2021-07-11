class Field {
  final String name;
  final String value;
  final String? verifiedAt;

  const Field({
    required this.name,
    required this.value,
    this.verifiedAt,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        name: json['name'],
        value: json['value'],
        verifiedAt: json['verified_at'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        if (verifiedAt != null) 'verified_at': verifiedAt,
      };
}
