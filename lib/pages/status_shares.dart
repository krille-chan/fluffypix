import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/fluffy_pix_api_extension.dart';
import 'package:flutter/material.dart';

import 'views/status_shares_view.dart';

class StatusSharesPage extends StatefulWidget {
  final String statusId;
  const StatusSharesPage({required this.statusId, Key? key}) : super(key: key);

  @override
  StatusSharesPageController createState() => StatusSharesPageController();
}

class StatusSharesPageController extends State<StatusSharesPage> {
  late final Future<List<Account>> request;
  @override
  void initState() {
    super.initState();
    request = FluffyPix.of(context).statusRebloggedBy(widget.statusId);
  }

  @override
  Widget build(BuildContext context) => StatusSharesPageView(this);
}
