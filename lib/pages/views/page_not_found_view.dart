import 'package:flutter/material.dart';

class PageNotFoundRouteView extends StatelessWidget {
  const PageNotFoundRouteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page not found...'),
      ),
    );
  }
}
