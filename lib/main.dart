import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/app_routes.dart';
import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/widgets/theme_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fluffyPix = FluffyPix();
  await fluffyPix.initialized;
  runApp(FluffyPixApp(fluffyPix: fluffyPix));
}

class FluffyPixApp extends StatelessWidget {
  final FluffyPix fluffyPix;
  const FluffyPixApp({Key? key, required this.fluffyPix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, themeMode, color) => DynamicColorBuilder(
        builder: (light, dark) => MaterialApp(
          title: AppConfigs.applicationName,
          themeMode: themeMode,
          theme: AppThemes.buildTheme(light, color, true),
          darkTheme: AppThemes.buildTheme(dark, color, false),
          builder: fluffyPix.builder,
          onGenerateRoute: AppRoutes(fluffyPix).onGenerateRoute,
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
        ),
      ),
    );
  }
}
