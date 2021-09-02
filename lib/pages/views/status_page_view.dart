import 'package:fluffypix/pages/status.dart';
import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class StatusPageView extends StatelessWidget {
  final StatusPageController controller;
  const StatusPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: DefaultBottomBar(
        scrollController: controller.scrollController,
      ),
    );
  }
}
