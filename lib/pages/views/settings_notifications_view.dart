import 'package:fluffypix/model/push_subscription.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../settings_notifications.dart';

class SettingsNotificationsPageView extends StatelessWidget {
  final SettingsNotificationsPageController controller;
  const SettingsNotificationsPageView(this.controller, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.notifications)),
      body: FutureBuilder<PushSubscriptionAlerts>(
          future: controller.alertsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    L10n.of(context)!.oopsSomethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final alerts = snapshot.data;
            if (alerts == null) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final loading = snapshot.connectionState != ConnectionState.done;
            return ListView(
              children: [
                SwitchListTile(
                  value: alerts.favourite ?? false,
                  onChanged: loading ? null : controller.toggleFavourite,
                  title: Text(L10n.of(context)!.forNewLikes),
                ),
                SwitchListTile(
                  value: alerts.follow ?? false,
                  onChanged: loading ? null : controller.toggleFollow,
                  title: Text(L10n.of(context)!.forNewFollowers),
                ),
                SwitchListTile(
                  value: alerts.mention ?? false,
                  onChanged: loading ? null : controller.toggleMention,
                  title: Text(L10n.of(context)!.forNewMentions),
                ),
                SwitchListTile(
                  value: alerts.reblog ?? false,
                  onChanged: loading ? null : controller.toggleReblog,
                  title: Text(L10n.of(context)!.forNewSharings),
                ),
                SwitchListTile(
                  value: alerts.poll ?? false,
                  onChanged: loading ? null : controller.togglePoll,
                  title: Text(L10n.of(context)!.forEndingPolls),
                ),
              ],
            );
          }),
    );
  }
}
