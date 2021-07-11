class Card {
  final String url;
  final String title;
  final String description;
  final String type;
  final String authorName;
  final String authorUrl;
  final String providerName;
  final String providerUrl;
  final String html;
  final int width;
  final int height;
  final String? image;
  final String embedUrl;

  const Card({
    required this.url,
    required this.title,
    required this.description,
    required this.type,
    required this.authorName,
    required this.authorUrl,
    required this.providerName,
    required this.providerUrl,
    required this.html,
    required this.width,
    required this.height,
    this.image,
    required this.embedUrl,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        url: json['url'],
        title: json['title'],
        description: json['description'],
        type: json['type'],
        authorName: json['author_name'],
        authorUrl: json['author_url'],
        providerName: json['provider_name'],
        providerUrl: json['provider_url'],
        html: json['html'],
        width: json['width'],
        height: json['height'],
        image: json['image'],
        embedUrl: json['embed_url'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'title': title,
        'description': description,
        'type': type,
        'author_name': authorName,
        'author_url': authorUrl,
        'provider_name': providerName,
        'provider_url': providerUrl,
        'html': html,
        'width': width,
        'height': height,
        if (image != null) 'image': image,
        'embed_url': embedUrl,
      };
}
