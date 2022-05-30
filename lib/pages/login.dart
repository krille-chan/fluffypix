import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/config/app_themes.dart';
import 'package:fluffypix/model/create_application_response.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_login_extension.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/views/login_view.dart';
import 'package:fluffypix/widgets/instance_info_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageController createState() => LoginPageController();
}

class LoginPageController extends State<LoginPage> {
  final TextEditingController searchController = TextEditingController();
  Future<List<PublicInstance>>? publicInstancesFuture;
  CreateApplicationResponse? _createApplicationResponse;
  StreamSubscription? _intentDataStreamSubscription;
  ChromeSafariBrowser? browser;

  @override
  void initState() {
    super.initState();
    _initReceiveUri();
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
  }

  Future<List<PublicInstance>> _requestInstances(String query) async {
    List<PublicInstance> instances = [];
    try {
      instances = await FluffyPix.of(context)
          .requestInstances(L10n.of(context)!.localeName, query);
    } finally {
      if (query.isNotEmpty &&
          !instances.any((instance) => instance.name == query)) {
        instances.add(
          PublicInstance(
            id: query,
            name: query,
          ),
        );
      }
      // ignore: control_flow_in_finally
      return instances;
    }
  }

  void _initReceiveUri() {
    if (kIsWeb || !(Platform.isIOS || Platform.isAndroid)) return;
    // For receiving shared Uris
    _intentDataStreamSubscription = linkStream.listen(_loginWithRedirectUrl);
  }

  Timer? _cooldown;

  void searchQueryWithCooldown([_]) {
    _cooldown?.cancel();
    _cooldown = Timer(const Duration(milliseconds: 500), searchQuery);
  }

  void searchQuery([_]) {
    setState(() {
      publicInstancesFuture = _requestInstances(searchController.text);
    });
  }

  void visitInstance(PublicInstance instance) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => InstanceInfoScaffold(instance: instance),
    );
  }

  Future<void> loginAction(String domain) async {
    browser ??= ChromeSafariBrowser();
    try {
      _createApplicationResponse =
          await FluffyPix.of(context).connectToInstance(domain, (url) async {
        if (FluffyPix.of(context).automaticRedirectUriAvailable) {
          browser ??= ChromeSafariBrowser();
          browser!.open(url: url);
        } else {
          launchUrl(url);
          final code = await showTextInputDialog(
            context: context,
            title: L10n.of(context)!.enterCode,
            okLabel: L10n.of(context)!.login,
            cancelLabel: L10n.of(context)!.cancel,
            textFields: [
              DialogTextField(hintText: L10n.of(context)!.enterCode),
            ],
          );
          if (code == null || code.isEmpty) return;
          _loginWithCode(code.single);
        }
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    }
    return;
  }

  void _loginWithRedirectUrl(String? url) async {
    await browser?.close();
    final createApplicationResponse = _createApplicationResponse;
    if (url == null || createApplicationResponse == null) return;
    debugPrint('RECEIVED: $url');
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];
    if (code == null) {
      throw Exception('Invalid URI');
    }
    _loginWithCode(code);
  }

  void _loginWithCode(String code) async {
    final createApplicationResponse = _createApplicationResponse;
    if (createApplicationResponse == null) return;
    await FluffyPix.of(context).login(code, createApplicationResponse);
    await Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
  }

  void _recommendMobileAppDialog([_]) {
    if (kIsWeb && !AppThemes.isColumnMode(context)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(L10n.of(context)!.recommendMobileApp),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConfigs.mobileApps
                .map(
                  (app) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: app.link == null
                          ? null
                          : () => launchUrlString(app.link!),
                      child: Opacity(
                        opacity: app.link == null ? 0.5 : 1,
                        child: Image.asset(
                          app.asset,
                          width: 164,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(L10n.of(context)!.noThanks),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_recommendMobileAppDialog);
    publicInstancesFuture ??=
        FluffyPix.of(context).requestInstances(L10n.of(context)!.localeName);
    return LoginPageView(this);
  }
}
