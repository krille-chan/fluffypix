import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultBottomBar extends StatefulWidget {
  final int? currentIndex;
  final ScrollController? scrollController;

  const DefaultBottomBar({
    Key? key,
    this.currentIndex,
    this.scrollController,
  }) : super(key: key);
  @override
  DefaultBottomBarController createState() => DefaultBottomBarController();
}

class DefaultBottomBarController extends State<DefaultBottomBar> {
  void onTap(int index) {
    if (index == widget.currentIndex) {
      if (widget.scrollController != null) {
        widget.scrollController!.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
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
        currentIndex: widget.currentIndex ?? 0,
        onTap: onTap,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.currentIndex == 2
                ? CupertinoIcons.add_circled_solid
                : CupertinoIcons.add_circled),
            label: 'Compose',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.currentIndex == 3
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.heart),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  FluffyPix.of(context).ownAccount?.avatar ?? ''),
              radius: 16,
            ),
            label: 'Account',
          ),
        ],
      );
}
