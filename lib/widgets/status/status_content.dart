import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/image_status_content.dart';
import 'package:fluffypix/widgets/status/text_status_content.dart';
import 'package:flutter/material.dart';

class StatusContent extends StatelessWidget {
  final Status status;
  const StatusContent({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status.mediaAttachments.isNotEmpty) {
      return ImageStatusContent(status: status);
    }
    return TextStatusContent(status: status);
  }
}
