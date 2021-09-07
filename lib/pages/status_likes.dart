import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_api_extension.dart';
import 'package:flutter/material.dart';

import 'views/status_likes_view.dart';

class StatusLikesPage extends StatefulWidget {
  final String statusId;
  const StatusLikesPage({required this.statusId, Key? key}) : super(key: key);

  @override
  StatusLikesPageController createState() => StatusLikesPageController();
}

class StatusLikesPageController extends State<StatusLikesPage> {
  late final Future<List<Account>> request;
  @override
  void initState() {
    super.initState();
    request = FluffyPix.of(context).statusFavouritedBy(widget.statusId);
  }

  @override
  Widget build(BuildContext context) => StatusLikesPageView(this);
}
