import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/pages/home.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:fluffypix/pages/notifications.dart';
import 'package:fluffypix/pages/search.dart';
import 'package:fluffypix/pages/settings.dart';
import 'package:fluffypix/pages/views/page_not_found_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  final FluffyPix fluffyPix;

  AppRoutes(this.fluffyPix);
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final route = settings.name;
    if (route == null) {
      return MaterialPageRoute(builder: (_) => PageNotFoundRouteView());
    }
    final parts = route.split('/');
    switch (parts[1]) {
      case '':
        return MaterialPageRoute(
            builder: (_) => fluffyPix.isLogged ? HomePage() : LoginPage());
      case 'notifications':
        return MaterialPageRoute(builder: (_) => NotificationsPage());
      case 'search':
        return MaterialPageRoute(builder: (_) => SearchPage());
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
    }
    return MaterialPageRoute(builder: (_) => PageNotFoundRouteView());
  }
}
