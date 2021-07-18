import 'dart:async';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uni_links/uni_links.dart';

import 'package:fluffypix/model/create_application_response.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/views/login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageController createState() => LoginPageController();
}

class LoginPageController extends State<LoginPage> {
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

  void _initReceiveUri() {
    if (kIsWeb || !(Platform.isIOS || Platform.isAndroid)) return;
    // For receiving shared Uris
    _intentDataStreamSubscription = linkStream.listen(_loginWithRedirectUrl);
    getInitialLink().then(_loginWithRedirectUrl);
  }

  void searchQuery(String? query) {
    setState(() {
      publicInstancesFuture = FluffyPix.of(context).requestInstances(query);
    });
  }

  void loginAction(String domain) async {
    browser ??= ChromeSafariBrowser();
    _createApplicationResponse = await FluffyPix.of(context)
        .connectToInstance(domain, (uri) => browser!.open(url: uri));
  }

  void _loginWithRedirectUrl(String? url) async {
    final createApplicationResponse = _createApplicationResponse;
    if (url == null || createApplicationResponse == null) return;
    debugPrint('RECEIVED: $url');
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];
    if (code == null) {
      throw Exception('Invalid URI');
    }
    await FluffyPix.of(context).login(code, createApplicationResponse);
    await Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    publicInstancesFuture ??= FluffyPix.of(context).requestInstances();
    return LoginPageView(this);
  }
}
