import 'package:flutter/material.dart';

import 'package:fluffypix/widgets/nav_scaffold.dart';

class PageNotFoundRouteView extends StatelessWidget {
  const PageNotFoundRouteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page not found...'),
      ),
    );
  }
}
