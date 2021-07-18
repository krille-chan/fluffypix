import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultBottomBar extends StatefulWidget {
  final int currentIndex;

  const DefaultBottomBar({Key? key, required this.currentIndex})
      : super(key: key);
  @override
  DefaultBottomBarController createState() => DefaultBottomBarController();
}

class DefaultBottomBarController extends State<DefaultBottomBar> {
  void onTap(int index) {
    if (index == widget.currentIndex) return;

    if (index == 0) {
      Navigator.of(context).popUntil((r) => r.isFirst);
      return;
    }

    late final String route;
    switch (index) {
      case 1:
        route = '/search';
        break;
      case 2:
        route = '/compose';
        break;
      case 3:
        route = '/notifications';
        break;
      case 4:
        route = '/settings';
        break;
      default:
        return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
        route, (route) => index == 0 ? false : route.isFirst);
  }

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
                widget.currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.currentIndex == 1
                ? Icons.search
                : Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.currentIndex == 2
                ? Icons.add_box
                : Icons.add_box_outlined),
            label: 'Compose',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.currentIndex == 3
                ? Icons.favorite
                : Icons.favorite_border_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.currentIndex == 4
                ? Icons.account_circle
                : Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      );
}
