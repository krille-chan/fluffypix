import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/pages/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageController createState() => HomePageController();
}

enum HomePagePopupMenuButtonAction {
  settings,
  logout,
}

class HomePageController extends State<HomePage> {
  Future<List<Status>>? timelineRequest;

  void settingsAction() => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => SettingsPage(),
        ),
      );

  void newStatusAction() {}

  @override
  Widget build(BuildContext context) {
    timelineRequest ??=
        FluffyPix.of(context).requestHomeTimeline().catchError((e, s) {
      debugPrint(e);
      debugPrint(s);
    });
    return HomePageView(this);
  }
}
