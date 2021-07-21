import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../search.dart';

class SearchPageView extends StatelessWidget {
  final SearchPageController controller;

  const SearchPageView(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: const DefaultBottomBar(currentIndex: 1),
    );
  }
}
