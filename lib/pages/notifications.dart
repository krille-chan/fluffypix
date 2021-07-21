import 'package:flutter/material.dart';

import 'views/notifications_view.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  NotificationsPageController createState() => NotificationsPageController();
}

class NotificationsPageController extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) => NotificationsPageView(this);
}
