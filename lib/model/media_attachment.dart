class MediaAttachment {
  final String id;
  final String? type;
  final Uri? url;
  final Uri? previewUrl;
  final Uri? remoteUrl;
  final Uri? previewRemoteUrl;
  final Uri? textUrl;
  final Map<String, ImageMeta>? meta;
  final String? description;
  final String? blurhash;

  const MediaAttachment({
    required this.id,
    this.type,
    this.url,
    this.previewUrl,
    this.remoteUrl,
    this.previewRemoteUrl,
    this.textUrl,
    this.meta,
    this.description,
    this.blurhash,
  });

  MediaAttachment.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        type = json['type'],
        url = Uri.tryParse(json['url'] ?? ''),
        previewUrl = Uri.tryParse(json['preview_url'] ?? ''),
        remoteUrl = Uri.tryParse(json['remote_url'] ?? ''),
        previewRemoteUrl = Uri.tryParse(json['prewview_remote_url'] ?? ''),
        textUrl = Uri.tryParse(json['text_url'] ?? ''),
        meta = json['meta'] != null
            ? (json['meta'] as Map)
                .map((k, v) => MapEntry(k, ImageMeta.fromJson(v)))
            : null,
        description = json['description'],
        blurhash = json['blurhash'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'url': url.toString(),
        'preview_url': previewUrl,
        'remote_url': remoteUrl,
        'prewview_remote_url': previewRemoteUrl,
        'text_url': textUrl,
        if (meta != null) 'meta': meta?.map((k, v) => MapEntry(k, v.toJson())),
        'description': description,
        'blurhash': blurhash,
      };
}

class ImageMeta {
  int? width;
  int? height;
  String? size;
  double? aspect;

  ImageMeta({this.width, this.height, this.size, this.aspect});

  ImageMeta.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        size = json['size'],
        aspect = json['aspect'];

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'size': size,
        'aspect': aspect,
      };
}
