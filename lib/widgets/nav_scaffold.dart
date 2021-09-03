import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/widgets/trending_hashtags_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'avatar.dart';

class NavScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget? body;
  final int? currentIndex;
  final ScrollController? scrollController;
  final Color? backgroundColor;
  const NavScaffold({
    Key? key,
    this.currentIndex,
    this.scrollController,
    this.appBar,
    this.body,
    this.backgroundColor,
  }) : super(key: key);

  static const double columnWidth = 300;

  void onTap(int index, BuildContext context) {
    if (index == currentIndex) {
      if (scrollController != null) {
        scrollController!.animateTo(
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
      case 5:
        route = '/settings';
        break;
      case 6:
        route = '/messages';
        break;
      default:
        return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
        route, (route) => index == 0 ? false : route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columnMode = constraints.maxWidth >= columnWidth * 3 + 3;
      final wideColumnMode = constraints.maxWidth >= columnWidth * 4 + 3;
      final scaffold = Scaffold(
        appBar: appBar,
        body: body,
        backgroundColor: backgroundColor,
        bottomNavigationBar: columnMode
            ? null
            : BottomNavigationBar(
                currentIndex:
                    (!columnMode && currentIndex != null && currentIndex! > 4)
                        ? 0
                        : currentIndex ?? 0,
                onTap: (i) => onTap(i, context),
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.home),
                    label: L10n.of(context)!.home,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.search),
                    label: L10n.of(context)!.account,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(currentIndex == 2
                        ? CupertinoIcons.add_circled_solid
                        : CupertinoIcons.add_circled),
                    label: L10n.of(context)!.newStatus,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(currentIndex == 3
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart),
                    label: L10n.of(context)!.notifications,
                  ),
                  BottomNavigationBarItem(
                    icon: Avatar(
                      account: FluffyPix.of(context).ownAccount!,
                      radius: 16,
                    ),
                    label: 'Account',
                  ),
                ],
              ),
      );
      if (!columnMode) return scaffold;
      return Scaffold(
        body: Row(
          children: [
            const Spacer(),
            SizedBox(
              width: columnWidth,
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset(
                      'assets/images/logo.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.home),
                    title: Text(L10n.of(context)!.home),
                    selected: currentIndex == 0,
                    onTap: () => onTap(0, context),
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.search),
                    title: Text(L10n.of(context)!.search),
                    selected: currentIndex == 1,
                    onTap: () => onTap(1, context),
                  ),
                  ListTile(
                    leading: Icon(currentIndex == 3
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart),
                    title: Text(L10n.of(context)!.notifications),
                    selected: currentIndex == 3,
                    onTap: () => onTap(3, context),
                  ),
                  ListTile(
                    leading: Icon(currentIndex == 6
                        ? CupertinoIcons.mail_solid
                        : CupertinoIcons.mail),
                    title: Text(L10n.of(context)!.messages),
                    onTap: () => onTap(6, context),
                    selected: currentIndex == 6,
                  ),
                  ListTile(
                    leading: Avatar(
                      account: FluffyPix.of(context).ownAccount!,
                      radius: 12,
                    ),
                    title: Text(L10n.of(context)!.account),
                    selected: currentIndex == 4,
                    onTap: () => onTap(4, context),
                  ),
                  ListTile(
                    leading: Icon(currentIndex == 5
                        ? CupertinoIcons.settings_solid
                        : CupertinoIcons.settings),
                    title: Text(L10n.of(context)!.settings),
                    onTap: () => onTap(5, context),
                    selected: currentIndex == 5,
                  ),
                  ListTile(
                    leading: Icon(currentIndex == 2
                        ? CupertinoIcons.add_circled_solid
                        : CupertinoIcons.add_circled),
                    title: Text(L10n.of(context)!.newStatus),
                    selected: currentIndex == 2,
                    onTap: () => onTap(2, context),
                  ),
                ],
              ),
            ),
            Container(width: 1, color: Theme.of(context).dividerColor),
            SizedBox(
              width: columnWidth * 2,
              child: scaffold,
            ),
            Container(width: 1, color: Theme.of(context).dividerColor),
            if (wideColumnMode)
              SizedBox(
                width: columnWidth * 1.25,
                child: ListView(
                  children: const [
                    TrendingHashtagsCard(),
                  ],
                ),
              ),
            const Spacer(),
          ],
        ),
      );
    });
  }
}
