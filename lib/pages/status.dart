import 'package:flutter/material.dart';

import 'views/status_page_view.dart';

class StatusPage extends StatefulWidget {
  final String statusId;
  const StatusPage({required this.statusId, Key? key}) : super(key: key);

  @override
  StatusPageController createState() => StatusPageController();
}

class StatusPageController extends State<StatusPage> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) => StatusPageView(this);
}
