import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/image_status_content.dart';
import 'package:fluffypix/widgets/status/text_status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class StatusContent extends StatefulWidget {
  final Status status;
  const StatusContent({required this.status, Key? key}) : super(key: key);

  @override
  _StatusContentState createState() => _StatusContentState();
}

class _StatusContentState extends State<StatusContent> {
  bool unlocked = false;
  @override
  Widget build(BuildContext context) {
    if (widget.status.sensitive && !unlocked) {
      return Container(
        height: 256,
        color: AppConfigs.primaryColor.withOpacity(0.05),
        alignment: Alignment.center,
        child: SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            onPressed: () => setState(() => unlocked = true),
            icon: const Icon(CupertinoIcons.lock),
            label: Text(L10n.of(context)!.nsfw),
          ),
        ),
      );
    }
    if (widget.status.mediaAttachments.isNotEmpty) {
      return ImageStatusContent(status: widget.status);
    }
    return TextStatusContent(status: widget.status);
  }
}
