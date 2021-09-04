import 'package:fluffypix/model/media_attachment.dart';
import 'package:fluffypix/widgets/status/attachment_viewer.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../nav_scaffold.dart';

class StatusContentSlider extends StatefulWidget {
  final ImageStatusMode imageStatusMode;
  final List<MediaAttachment> attachments;
  const StatusContentSlider({
    required this.attachments,
    required this.imageStatusMode,
    Key? key,
  }) : super(key: key);

  @override
  _StatusContentSliderState createState() => _StatusContentSliderState();
}

class _StatusContentSliderState extends State<StatusContentSlider> {
  final PageController pageController = PageController();

  num get currentPage =>
      (pageController.hasClients ? pageController.page ?? 0 : 0);

  @override
  void initState() {
    pageController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    pageController.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attachments.length == 1) {
      return AttachmentViewer(
        attachment: widget.attachments.single,
        imageStatusMode: widget.imageStatusMode,
      );
    }
    final width =
        (MediaQuery.of(context).size.width > (NavScaffold.columnWidth * 3 + 3))
            ? NavScaffold.columnWidth * 2
            : MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          height: width,
          child: PageView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: widget.attachments
                .map((attachment) => Center(
                      child: AttachmentViewer(
                        attachment: attachment,
                        imageStatusMode: widget.imageStatusMode,
                      ),
                    ))
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_left,
                size: 16,
              ),
              splashRadius: Material.defaultSplashRadius / 2,
              onPressed: currentPage == 0
                  ? null
                  : () => pageController.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      ),
            ),
            for (var i = 0; i < widget.attachments.length; i++)
              IconButton(
                icon: Icon(
                  currentPage == i
                      ? CupertinoIcons.circle_fill
                      : CupertinoIcons.circle,
                  size: 16,
                ),
                splashRadius: Material.defaultSplashRadius / 2,
                onPressed: () => pageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                ),
              ),
            IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_right,
                size: 16,
              ),
              splashRadius: Material.defaultSplashRadius / 2,
              onPressed: currentPage == widget.attachments.length - 1
                  ? null
                  : () => pageController.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      ),
            ),
          ],
        ),
      ],
    );
  }
}
