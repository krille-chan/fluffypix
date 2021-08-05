import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/pages/compose.dart';
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
      return MaterialPageRoute(builder: (_) => const PageNotFoundRouteView());
    }
    final parts = route.split('/');
    switch (parts[1]) {
      case '':
        return _fadeRoute(
            builder: (_) =>
                fluffyPix.isLogged ? const HomePage() : const LoginPage());
      case 'notifications':
        return _fadeRoute(builder: (_) => const NotificationsPage());
      case 'search':
        return _fadeRoute(builder: (_) => const SearchPage());
      case 'compose':
        return _fadeRoute(builder: (_) => const ComposePage());
      case 'settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
    }
    return MaterialPageRoute(builder: (_) => const PageNotFoundRouteView());
  }

  Route _fadeRoute({required Widget Function(BuildContext) builder}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
