import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/app_routes.dart';
import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

void main() async {
  final fluffyPix = FluffyPix();
  await fluffyPix.initialized;
  runApp(FluffyPixApp(fluffyPix: fluffyPix));
}

class FluffyPixApp extends StatelessWidget {
  final FluffyPix fluffyPix;
  const FluffyPixApp({Key? key, required this.fluffyPix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfigs.applicationName,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      builder: fluffyPix.builder,
      onGenerateRoute: AppRoutes(fluffyPix).onGenerateRoute,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
    );
  }
}
