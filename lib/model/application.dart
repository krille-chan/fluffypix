class Application {
  final String name;
  final String? website;

  const Application({
    required this.name,
    this.website,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        name: json['name'],
        website: json['website'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (website != null) 'website': website,
      };
}
