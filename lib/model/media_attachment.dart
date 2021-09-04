import '../utils/convert_to_json.dart';

class MediaAttachment {
  final String id;
  final MediaType type;
  final Uri url;
  final Uri previewUrl;
  final Uri? remoteUrl;
  final Uri? previewRemoteUrl;
  final Uri? textUrl;
  final Map<String, dynamic>? meta;
  final String? description;
  final String? blurhash;

  const MediaAttachment({
    required this.id,
    required this.type,
    required this.url,
    required this.previewUrl,
    this.remoteUrl,
    this.previewRemoteUrl,
    this.textUrl,
    this.meta,
    this.description,
    this.blurhash,
  });

  MediaAttachment.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        type = MediaType.values
            .firstWhere((v) => v.toString().split('.').last == json['type']),
        url = Uri.parse(json['url']),
        previewUrl = Uri.parse(json['preview_url']),
        remoteUrl = Uri.tryParse(json['remote_url'] ?? ''),
        previewRemoteUrl = Uri.tryParse(json['prewview_remote_url'] ?? ''),
        textUrl = Uri.tryParse(json['text_url'] ?? ''),
        meta = json['meta'] == null ? null : (json['meta'] as Map).toJson(),
        description = json['description'],
        blurhash = json['blurhash'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString().split('.').last,
        'url': url.toString(),
        'preview_url': previewUrl.toString(),
        'remote_url': remoteUrl.toString(),
        'prewview_remote_url': previewRemoteUrl?.toString(),
        'text_url': textUrl?.toString(),
        if (meta != null)
          'meta': meta?.map((k, v) => MapEntry(k, (v as Map).toJson())),
        'description': description,
        'blurhash': blurhash,
      };

  ImageMeta get imageMeta => ImageMeta.fromJson(meta ?? {});
  VideoMeta get videoMeta => VideoMeta.fromJson(meta ?? {});
  AudioMeta get audioMeta => AudioMeta.fromJson(meta ?? {});
  GifMeta get gifMeta => GifMeta.fromJson(meta ?? {});
}

enum MediaType { image, video, gifv, audio, unknown }

class ImageMeta {
  final ImageMetaInfo? original;
  final ImageMetaInfo? small;
  final Focus? focus;

  const ImageMeta({
    this.original,
    this.small,
    this.focus,
  });

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
        original: json['original'] == null
            ? null
            : ImageMetaInfo.fromJson(json['original']),
        small: json['small'] == null
            ? null
            : ImageMetaInfo.fromJson(json['small']),
        focus: json['focus'] == null ? null : Focus.fromJson(json['focus']),
      );

  Map<String, dynamic> toJson() => {
        if (original != null) 'original': original!.toJson(),
        if (small != null) 'small': small!.toJson(),
        if (focus != null) 'focus': focus!.toJson(),
      };
}

class ImageMetaInfo {
  final int? width;
  final int? height;
  final String? size;
  final double? aspect;

  const ImageMetaInfo({
    this.width,
    this.height,
    this.size,
    this.aspect,
  });

  factory ImageMetaInfo.fromJson(Map<String, dynamic> json) => ImageMetaInfo(
        width: json['width'],
        height: json['height'],
        size: json['size'],
        aspect: json['aspect'],
      );

  Map<String, dynamic> toJson() => {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (size != null) 'size': size,
        if (aspect != null) 'aspect': aspect,
      };
}

class Focus {
  final double? x;
  final double? y;

  const Focus({
    this.x,
    this.y,
  });

  factory Focus.fromJson(Map<String, dynamic> json) => Focus(
        x: json['x'],
        y: json['y'],
      );

  Map<String, dynamic> toJson() => {
        if (x != null) 'x': x,
        if (y != null) 'y': y,
      };
}

class VideoMeta {
  final String? length;
  final double? duration;
  final int? fps;
  final String? size;
  final int? width;
  final int? height;
  final double? aspect;
  final String? audioEncode;
  final String? audioBitrate;
  final String? audioChannels;
  final VideoMetaInfo? original;
  final ImageMetaInfo? small;

  const VideoMeta({
    this.length,
    this.duration,
    this.fps,
    this.size,
    this.width,
    this.height,
    this.aspect,
    this.audioEncode,
    this.audioBitrate,
    this.audioChannels,
    this.original,
    this.small,
  });

  factory VideoMeta.fromJson(Map<String, dynamic> json) => VideoMeta(
        length: json['length'],
        duration: json['duration'],
        fps: json['fps'],
        size: json['size'],
        width: json['width'],
        height: json['height'],
        aspect: json['aspect'],
        audioEncode: json['audio_encode'],
        audioBitrate: json['audio_bitrate'],
        audioChannels: json['audio_channels'],
        original: json['original'] == null
            ? null
            : VideoMetaInfo.fromJson(json['original']),
        small: json['small'] == null
            ? null
            : ImageMetaInfo.fromJson(json['small']),
      );

  Map<String, dynamic> toJson() => {
        if (length != null) 'length': length,
        if (duration != null) 'duration': duration,
        if (fps != null) 'fps': fps,
        if (size != null) 'size': size,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (aspect != null) 'aspect': aspect,
        if (audioEncode != null) 'audio_encode': audioEncode,
        if (audioBitrate != null) 'audio_bitrate': audioBitrate,
        if (audioChannels != null) 'audio_channels': audioChannels,
        if (original != null) 'original': original!.toJson(),
        if (small != null) 'small': small!.toJson(),
      };
}

class VideoMetaInfo {
  final int? width;
  final int? height;
  final String? frameRate;
  final double? duration;
  final int? bitrate;

  const VideoMetaInfo({
    this.width,
    this.height,
    this.frameRate,
    this.duration,
    this.bitrate,
  });

  factory VideoMetaInfo.fromJson(Map<String, dynamic> json) => VideoMetaInfo(
        width: json['width'],
        height: json['height'],
        frameRate: json['frame_rate'],
        duration: json['duration'],
        bitrate: json['bitrate'],
      );

  Map<String, dynamic> toJson() => {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (frameRate != null) 'frame_rate': frameRate,
        if (duration != null) 'duration': duration,
        if (bitrate != null) 'bitrate': bitrate,
      };
}

class GifMeta {
  final String? length;
  final double? duration;
  final int? fps;
  final String? size;
  final int? width;
  final int? height;
  final double? aspect;
  final VideoMetaInfo? original;
  final ImageMetaInfo? small;

  const GifMeta({
    this.length,
    this.duration,
    this.fps,
    this.size,
    this.width,
    this.height,
    this.aspect,
    this.original,
    this.small,
  });

  factory GifMeta.fromJson(Map<String, dynamic> json) => GifMeta(
        length: json['length'],
        duration: json['duration'],
        fps: json['fps'],
        size: json['size'],
        width: json['width'],
        height: json['height'],
        aspect: json['aspect'],
        original: json['original'] == null
            ? null
            : VideoMetaInfo.fromJson(json['original']),
        small: json['small'] == null
            ? null
            : ImageMetaInfo.fromJson(json['small']),
      );

  Map<String, dynamic> toJson() => {
        if (length != null) 'length': length,
        if (duration != null) 'duration': duration,
        if (fps != null) 'fps': fps,
        if (size != null) 'size': size,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (aspect != null) 'aspect': aspect,
        if (original != null) 'original': original!.toJson(),
        if (small != null) 'small': small!.toJson(),
      };
}

class AudioMeta {
  final String? length;
  final double? duration;
  final String? audioEncode;
  final String? audioBitrate;
  final String? audioChannels;
  final AudioMetaInfo? original;

  const AudioMeta({
    this.length,
    this.duration,
    this.audioEncode,
    this.audioBitrate,
    this.audioChannels,
    this.original,
  });

  factory AudioMeta.fromJson(Map<String, dynamic> json) => AudioMeta(
        length: json['length'],
        duration: json['duration'],
        audioEncode: json['audio_encode'],
        audioBitrate: json['audio_bitrate'],
        audioChannels: json['audio_channels'],
        original: json['original'] == null
            ? null
            : AudioMetaInfo.fromJson(json['original']),
      );

  Map<String, dynamic> toJson() => {
        if (length != null) 'length': length,
        if (duration != null) 'duration': duration,
        if (audioEncode != null) 'audio_encode': audioEncode,
        if (audioBitrate != null) 'audio_bitrate': audioBitrate,
        if (audioChannels != null) 'audio_channels': audioChannels,
        if (original != null) 'original': original!.toJson(),
      };
}

class AudioMetaInfo {
  final double? duration;
  final int? bitrate;

  const AudioMetaInfo({
    this.duration,
    this.bitrate,
  });

  factory AudioMetaInfo.fromJson(Map<String, dynamic> json) => AudioMetaInfo(
        duration: json['duration'],
        bitrate: json['bitrate'],
      );

  Map<String, dynamic> toJson() => {
        if (duration != null) 'duration': duration,
        if (bitrate != null) 'bitrate': bitrate,
      };
}
