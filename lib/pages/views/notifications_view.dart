import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../notifications.dart';

class NotificationsPageView extends StatelessWidget {
  final NotificationsPageController controller;

  const NotificationsPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: DefaultBottomBar(
        currentIndex: 3,
        scrollController: controller.scrollController,
      ),
    );
  }
}
