import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:fluffypix/widgets/status/image_status_content.dart';
import 'package:fluffypix/widgets/status/sensitive_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

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
    final hide = widget.status.sensitive && !unlocked;
    final content = hide
        ? SensitiveContent(
            onUnlock: () => setState(() => unlocked = true),
          )
        : ImageStatusContent(
            status: widget.status,
            imageStatusMode: widget.imageStatusMode,
          );
    if (widget.imageStatusMode == ImageStatusMode.discover) return content;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        if (widget.status.mediaAttachments.isNotEmpty ||
            widget.imageStatusMode == ImageStatusMode.reply)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: RichText(
              text: HTML.toTextSpan(context, (widget.status.content ?? ''),
                  linksCallback: (link) => linksCallback(link, context),
                  overrideStyle: {
                    'a': TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                    ),
                  }),
            ),
          ),
      ],
    );
  }
}
