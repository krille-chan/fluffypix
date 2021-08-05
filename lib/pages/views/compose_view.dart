import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../model/status_visibility.dart';

import '../compose.dart';

class ComposePageView extends StatelessWidget {
  final ComposePageController controller;
  const ComposePageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.widget.dmUser != null
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
                TextField(
                  minLines: 8,
                  maxLines: 8,
                  maxLength: 500,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  controller: controller.statusController,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.howDoYouFeel,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                if (controller.media.isNotEmpty) ...{
                  const SizedBox(height: 12),
                  controller.media.length == 1
                      ? _PickedImage(controller, 0)
                      : SizedBox(
                          height: 256,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.media.length,
                            itemBuilder: (context, i) =>
                                _PickedImage(controller, i),
                          ),
                        ),
                },
                const SizedBox(height: 12),
                SizedBox(
                  height: 64,
                  child: OutlinedButton.icon(
                    onPressed:
                        controller.loadingPhoto ? null : controller.addMedia,
                    icon: controller.loadingPhoto
                        ? const CupertinoActivityIndicator()
                        : const Icon(CupertinoIcons.camera),
                    label: Text(controller.loadingPhoto
                        ? L10n.of(context)!.loading
                        : L10n.of(context)!.addMedia),
                  ),
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
      bottomNavigationBar: const DefaultBottomBar(currentIndex: 2),
    );
  }
}

class _PickedImage extends StatelessWidget {
  final ComposePageController controller;
  final int i;
  const _PickedImage(this.controller, this.i, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.memory(
          controller.media[i],
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
