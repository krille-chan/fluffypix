import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/pages/compose.dart';
import 'package:fluffypix/pages/hashtag.dart';
import 'package:fluffypix/pages/home.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:fluffypix/pages/messages.dart';
import 'package:fluffypix/pages/notifications.dart';
import 'package:fluffypix/pages/search.dart';
import 'package:fluffypix/pages/settings.dart';
import 'package:fluffypix/pages/status.dart';
import 'package:fluffypix/pages/user.dart';
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
        final dmUser = settings.arguments as Account?;
        return _fadeRoute(builder: (_) => ComposePage(dmUser: dmUser));
      case 'messages':
        return _fadeRoute(builder: (_) => const MessagesPage());
      case 'settings':
        return _fadeRoute(builder: (_) => const SettingsPage());
      case 'tags':
        if (parts.length == 3) {
          return _fadeRoute(builder: (_) => HashtagPage(hashtag: parts[2]));
        }
        break;
      case 'user':
        if (parts.length == 3) {
          return _fadeRoute(builder: (_) => UserPage(id: parts[2]));
        }
        break;
      case 'status':
        if (parts.length == 3) {
          return _fadeRoute(builder: (_) => StatusPage(statusId: parts[2]));
        }
        break;
    }
    return _fadeRoute(builder: (_) => const PageNotFoundRouteView());
  }

  Route _fadeRoute({required Widget Function(BuildContext) builder}) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
  }
}
