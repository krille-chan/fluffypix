import 'package:fluffypix/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;
  const LoginView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Center(
        child: Text(L10n.of(context)!.helloWorld),
      ),
    );
  }
}
