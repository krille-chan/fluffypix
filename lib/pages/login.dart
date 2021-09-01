import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uni_links/uni_links.dart';

import 'package:fluffypix/model/create_application_response.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/views/login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
    final instances = await FluffyPix.of(context)
        .requestInstances(L10n.of(context)!.localeName, query);
    if (instances.isEmpty &&
        query.isNotEmpty &&
        !instances.any((instance) => instance.name == query)) {
      instances.add(
        PublicInstance(
          id: query,
          name: query,
        ),
      );
    }
    return instances;
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
    final description =
        '${L10n.of(context)!.members}: ${instance.users ?? L10n.of(context)!.unknown}\n${L10n.of(context)!.statuses}: ${instance.statuses ?? L10n.of(context)!.unknown}\n${instance.fullDescription ?? instance.shortDescription}';
    final result = await showOkCancelAlertDialog(
      context: context,
      title: instance.name,
      message: description,
      okLabel: 'Visit website',
      cancelLabel: L10n.of(context)!.close,
    );
    if (result == OkCancelResult.ok) {
      launch(Uri.https(instance.name, '/').toString(),
          forceSafariVC: true, forceWebView: true);
    }
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
          launch(url.toString());
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

  @override
  Widget build(BuildContext context) {
    publicInstancesFuture ??=
        FluffyPix.of(context).requestInstances(L10n.of(context)!.localeName);
    return LoginPageView(this);
  }
}
