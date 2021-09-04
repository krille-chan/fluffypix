import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/widgets/status/attachment_viewer.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../nav_scaffold.dart';

class StatusContentSlider extends StatefulWidget {
  final ImageStatusMode imageStatusMode;
  final Status status;
  const StatusContentSlider({
    required this.status,
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
    if (widget.imageStatusMode == ImageStatusMode.discover) {
      return InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed('/status/${widget.status.id}'),
        child: Stack(
          children: [
            AttachmentViewer(
              attachment: widget.status.mediaAttachments.first,
              imageStatusMode: widget.imageStatusMode,
            ),
            if (widget.status.mediaAttachments.length > 1)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(
                  CupertinoIcons.square_stack_fill,
                  color: Colors.white,
                ),
              )
          ],
        ),
      );
    }
    if (widget.status.mediaAttachments.length == 1) {
      return AttachmentViewer(
        attachment: widget.status.mediaAttachments.single,
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
            children: widget.status.mediaAttachments
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
            for (var i = 0; i < widget.status.mediaAttachments.length; i++)
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
              onPressed:
                  currentPage == widget.status.mediaAttachments.length - 1
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
