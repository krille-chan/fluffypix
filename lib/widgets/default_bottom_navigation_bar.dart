import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultBottomBar extends StatefulWidget {
  final int currentIndex;
  final void Function()? onCurrentIndexTab;

  const DefaultBottomBar({
    Key? key,
    required this.currentIndex,
    this.onCurrentIndexTab,
  }) : super(key: key);
  @override
  DefaultBottomBarController createState() => DefaultBottomBarController();
}

class DefaultBottomBarController extends State<DefaultBottomBar> {
  void onTap(int index) {
    if (index == widget.currentIndex) {
      widget.onCurrentIndexTab?.call();
      return;
    }

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
        route = '/user/${FluffyPix.of(context).ownAccount?.id}';
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: 'Compose',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Account',
          ),
        ],
      );
}
