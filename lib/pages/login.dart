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
    final instances = await FluffyPix.of(context).requestInstances(query);
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
    getInitialLink().then(_loginWithRedirectUrl);
  }

  Timer? _cooldown;

  void searchQueryWithCooldown([_]) {
    _cooldown?.cancel();
    _cooldown = Timer(const Duration(seconds: 1), searchQuery);
  }

  void searchQuery([_]) {
    setState(() {
      publicInstancesFuture = _requestInstances(searchController.text);
    });
  }

  void loginAction(String domain) async {
    browser ??= ChromeSafariBrowser();
    _createApplicationResponse =
        await FluffyPix.of(context).connectToInstance(domain, (url) {
      browser ??= ChromeSafariBrowser();
      browser!.open(url: url);
    });
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
    await FluffyPix.of(context).login(code, createApplicationResponse);
    await Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    publicInstancesFuture ??= FluffyPix.of(context).requestInstances();
    return LoginPageView(this);
  }
}
