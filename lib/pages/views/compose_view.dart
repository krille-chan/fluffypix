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
          onPressed: controller.loading ? null : controller.resetAction,
        ),
        actions: [
          TextButton(
            onPressed: controller.loading ? null : controller.postAction,
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
                const SizedBox(height: 12),
                SizedBox(
                  height: 64,
                  child: OutlinedButton.icon(
                    onPressed: controller.addMedia,
                    icon: const Icon(CupertinoIcons.camera),
                    label: Text(L10n.of(context)!.addMedia),
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
