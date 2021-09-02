import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class PageNotFoundRouteView extends StatelessWidget {
  const PageNotFoundRouteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page not found...'),
      ),
      bottomNavigationBar: const DefaultBottomBar(),
    );
  }
}
