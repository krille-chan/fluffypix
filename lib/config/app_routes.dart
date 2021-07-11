import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  final FluffyPix fluffyPix;

  AppRoutes(this.fluffyPix);
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => Login());
  }
}
