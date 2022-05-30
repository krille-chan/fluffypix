import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import '../../model/status_visibility.dart';
import '../compose.dart';

class ComposePageView extends StatelessWidget {
  final ComposePageController controller;
  const ComposePageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(
        title: Text(controller.visibility == StatusVisibility.direct
            ? L10n.of(context)!.newMessage
            : L10n.of(context)!.newStatus),
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: TextButton(
          child: Text(L10n.of(context)!.reset),
          onPressed: controller.loading || controller.loadingPhoto
              ? null
              : controller.resetAction,
        ),
        actions: [
          TextButton(
            onPressed: controller.loading || controller.loadingPhoto
                ? null
                : controller.postAction,
            child: Row(
              children: [
                Text(L10n.of(context)!.post),
                const SizedBox(width: 8),
                const Icon(Icons.send_outlined),
              ],
            ),
          ),
        ],
      ),
      body: controller.loading
          ? const Center(child: CupertinoActivityIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (controller.media.isNotEmpty) ...[
                  controller.media.length == 1
                      ? Center(child: _PickedImage(controller, 0))
                      : SizedBox(
                          height: 256,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.media.length,
                            itemBuilder: (context, i) =>
                                _PickedImage(controller, i),
                          ),
                        ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 500,
                  controller: controller.statusController,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.howDoYouFeel,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 12),
                controller.loadingPhoto
                    ? const SizedBox(
                        height: 64,
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: controller.addMedia,
                                icon: const Icon(CupertinoIcons.photo),
                                label: Text(L10n.of(context)!.addPhoto),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    controller.addMedia(video: true),
                                icon: const Icon(CupertinoIcons.video_camera),
                                label: Text(L10n.of(context)!.addVideo),
                              ),
                            ),
                          ),
                        ],
                      ),
                ListTile(
                  onTap: controller.setVisibility,
                  trailing: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(controller.visibility.icon),
                  ),
                  title: Text(L10n.of(context)!.visibility),
                  subtitle:
                      Text(controller.visibility.toLocalizedString(context)),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: controller.sensitive,
                  onChanged: controller.toggleSensitive,
                  title: Text(L10n.of(context)!.nsfw),
                ),
              ],
            ),
      currentIndex: 2,
    );
  }
}

class _PickedImage extends StatelessWidget {
  final ComposePageController controller;
  final int i;
  const _PickedImage(this.controller, this.i, {Key? key}) : super(key: key);

  String format(double bytes) {
    final dictionary = [
      "bytes",
      "KB",
      "MB",
      "GB",
      "TB",
      "PB",
      "EB",
      "ZB",
      "YB"
    ];
    int index = 0;
    for (index = 0; index < dictionary.length; index++) {
      if (bytes < 1024) {
        break;
      }
      bytes = bytes / 1024;
    }
    return '${(bytes * 100).round() / 100} ${dictionary[index]}';
  }

  @override
  Widget build(BuildContext context) {
    final media = controller.media[i];
    return Stack(
      children: [
        media.video
            ? Container(
                height: 256,
                color: Theme.of(context).dividerColor,
                child: Stack(
                  children: [
                    const BlurHash(hash: AppConfigs.fallbackBlurHash),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.video_camera_solid,
                            size: 56,
                          ),
                          Text(format(media.bytes.length.toDouble())),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Image.memory(
                media.bytes,
                fit: BoxFit.cover,
              ),
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.close),
          onPressed: () => controller.removeMedia(i),
        ),
      ],
    );
  }
}
