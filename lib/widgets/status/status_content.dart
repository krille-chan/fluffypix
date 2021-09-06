import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simple_html_css/simple_html_css.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:fluffypix/widgets/status/sensitive_content.dart';
import 'package:fluffypix/widgets/status/status_content_slider.dart';
import 'package:fluffypix/widgets/status/text_status_content.dart';

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
    final contentStatus = widget.status.reblog ?? widget.status;
    final hide = contentStatus.sensitive && !unlocked;
    late final Widget content;
    if (hide) {
      content = SensitiveContent(
        blurHash: contentStatus.mediaAttachments.isEmpty
            ? AppConfigs.fallbackBlurHash
            : contentStatus.mediaAttachments.first.blurhash ??
                AppConfigs.fallbackBlurHash,
        onUnlock: () => setState(() => unlocked = true),
      );
    } else if (contentStatus.mediaAttachments.isNotEmpty) {
      content = StatusContentSlider(
        status: contentStatus,
        imageStatusMode: widget.imageStatusMode,
      );
    } else {
      content = TextStatusContent(
        status: contentStatus,
        imageStatusMode: widget.imageStatusMode,
      );
    }
    if (widget.imageStatusMode == ImageStatusMode.discover) {
      return InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed('/status/${widget.status.id}'),
          child: content);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        if (contentStatus.mediaAttachments.isNotEmpty ||
            contentStatus.card?.image != null ||
            widget.imageStatusMode == ImageStatusMode.reply)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: RichText(
              text: HTML.toTextSpan(context, (contentStatus.content ?? ''),
                  linksCallback: (link) => linksCallback(link, context),
                  defaultTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
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
