import 'package:fluffypix/pages/views/login_view.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  @override
  Widget build(BuildContext context) => LoginView(this);
}
