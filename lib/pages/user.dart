import 'package:flutter/material.dart';

import 'views/user_view.dart';

class UserPage extends StatefulWidget {
  final String username;
  const UserPage({required this.username, Key? key}) : super(key: key);

  @override
  UserPageController createState() => UserPageController();
}

class UserPageController extends State<UserPage> {
  @override
  Widget build(BuildContext context) => UserPageView(this);
}
