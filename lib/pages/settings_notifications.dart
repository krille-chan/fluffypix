import 'package:flutter/material.dart';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_api_extension.dart';
import 'package:fluffypix/model/fluffy_pix_push_extension.dart';
import 'package:fluffypix/model/push_subscription.dart';
import 'views/settings_notifications_view.dart';

class SettingsNotificationsPage extends StatefulWidget {
  const SettingsNotificationsPage({Key? key}) : super(key: key);

  @override
  SettingsNotificationsPageController createState() =>
      SettingsNotificationsPageController();
}

class SettingsNotificationsPageController
    extends State<SettingsNotificationsPage> {
  late Future<PushSubscriptionAlerts> alertsFuture;
  PushSubscriptionAlerts? alerts;
  bool error = false;

  @override
  void initState() {
    super.initState();
    alertsFuture = _onInitialSubscriptionLoading();
  }

  void toggleFavourite(bool b) => setState(() {
        alerts!.favourite = b;
        alertsFuture = _updateAlerts();
      });

  void toggleFollow(bool b) => setState(() {
        alerts!.follow = b;
        alertsFuture = _updateAlerts();
      });

  void toggleMention(bool b) => setState(() {
        alerts!.mention = b;
        alertsFuture = _updateAlerts();
      });

  void togglePoll(bool b) => setState(() {
        alerts!.poll = b;
        alertsFuture = _updateAlerts();
      });

  void toggleReblog(bool b) => setState(() {
        alerts!.reblog = b;
        alertsFuture = _updateAlerts();
      });

  Future<PushSubscriptionAlerts> _updateAlerts() async {
    await FluffyPix.of(context).setPushsubcriptionAlerts(alerts!);
    final subscription =
        await FluffyPix.of(context).getCurrentPushSubscription();
    return alerts = subscription!.alerts;
  }

  Future<PushSubscriptionAlerts> _onInitialSubscriptionLoading() async {
    var subscription = await FluffyPix.of(context).getCurrentPushSubscription();
    if (subscription != null) return alerts = subscription.alerts;
    await FluffyPix.of(context).initPush();
    subscription = await FluffyPix.of(context).getCurrentPushSubscription();
    return subscription!.alerts;
  }

  @override
  Widget build(BuildContext context) => SettingsNotificationsPageView(this);
}
