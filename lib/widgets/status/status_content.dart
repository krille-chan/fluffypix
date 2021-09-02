import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/image_status_content.dart';
import 'package:fluffypix/widgets/status/sensitive_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ImageStatusMode { timeline, reply, discover }

class StatusContent extends StatefulWidget {
  final Status status;
  final ImageStatusMode imageStatusMode;
  const StatusContent({
    required this.status,
    this.imageStatusMode = ImageStatusMode.timeline,
    Key? key,
  }) : super(key: key);

  @override
  _StatusContentState createState() => _StatusContentState();
}

class _StatusContentState extends State<StatusContent> {
  bool unlocked = false;
  @override
  Widget build(BuildContext context) {
    if (widget.status.sensitive && !unlocked) {
      return SensitiveContent(
        onUnlock: () => setState(() => unlocked = true),
      );
    }
    return ImageStatusContent(
      status: widget.status,
      imageStatusMode: widget.imageStatusMode,
    );
  }
}
