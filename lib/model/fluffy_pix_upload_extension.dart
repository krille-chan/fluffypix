import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

import 'fluffy_pix.dart';
import 'media_attachment.dart';

extension FluffyPixUploadExtension on FluffyPix {
  Future<MediaAttachment> upload(Uint8List bytes, String filename) async {
    final request = MultipartRequest(
      'POST',
      instance!.resolveUri(
        Uri(path: '/api/v1/media'),
      ),
    );
    request.files.add(
      MultipartFile.fromBytes('file', bytes,
          filename: filename.split("/").last),
    );
    request.headers['Authorization'] =
        'Bearer ${accessTokenCredentials?.accessToken}';

    final streamedResponse = await request.send();
    var respBody = await streamedResponse.stream.bytesToString();
    return MediaAttachment.fromJson(jsonDecode(respBody));
  }
}
