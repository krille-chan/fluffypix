import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:fluffypix/utils/custom_about_dialog.dart';
import 'package:fluffypix/widgets/instance_list_item.dart';

class LoginPageView extends StatelessWidget {
  final LoginPageController controller;
  const LoginPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context)!.pickACommunity),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.info),
            onPressed: () => showCustomAboutDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<PublicInstance>>(
          future: controller.publicInstancesFuture,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final instances = snapshot.data ?? [];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    right: 12,
                    left: 12,
                  ),
                  child: Center(
                      child: Text(
                    L10n.of(context)!.pickACommunityDescription,
                    textAlign: TextAlign.center,
                  )),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: controller.searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: controller.searchQueryWithCooldown,
                      onSubmitted: isLoading ? null : controller.searchQuery,
                      decoration: InputDecoration(
                        suffixIcon: isLoading
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(CupertinoIcons.search),
                                onPressed: controller.searchQuery,
                              ),
                        hintText: L10n.of(context)!.search,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      left: 12.0,
                      right: 12.0,
                    ),
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 32),
                        separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color:
                                Theme.of(context).textTheme.bodyText1?.color),
                        itemCount: instances.length,
                        itemBuilder: (context, i) => InstanceListItem(
                          instance: instances[i],
                          controller: controller,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
    if (!AppThemes.isColumnMode(context)) {
      return scaffold;
    }
    return Scaffold(
      body: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: AppThemes.columnWidth,
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 56,
                  height: 56,
                ),
                const SizedBox(height: 4),
                const Text(
                  AppConfigs.applicationName,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                if (kIsWeb) ...[
                  const SizedBox(height: 4),
                  Text(
                    L10n.of(context)!.tryOutMobileApps,
                    textAlign: TextAlign.center,
                  ),
                  for (final app in AppConfigs.mobileApps)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap:
                              app.link == null ? null : () => launch(app.link!),
                          child: Opacity(
                            opacity: app.link == null ? 0.5 : 1,
                            child: Image.asset(
                              app.asset,
                              width: 164,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          Container(width: 1, color: Theme.of(context).dividerColor),
          SizedBox(width: AppThemes.mainColumnWidth, child: scaffold),
          Container(width: 1, color: Theme.of(context).dividerColor),
          const Spacer(),
        ],
      ),
    );
  }
}
