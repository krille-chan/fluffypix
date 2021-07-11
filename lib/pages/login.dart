import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/views/login_view.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  Future<List<PublicInstance>>? publicInstancesFuture;

  void searchQuery(String? query) {
    setState(() {
      publicInstancesFuture = FluffyPix.of(context).requestInstances(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    publicInstancesFuture ??= FluffyPix.of(context).requestInstances();
    return LoginView(this);
  }
}
