import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/widgets/account_list_tile.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../status_likes.dart';

class StatusLikesPageView extends StatelessWidget {
  final StatusLikesPageController controller;
  const StatusLikesPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.wasLikedBy)),
      body: FutureBuilder<List<Account>>(
        future: controller.request,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                L10n.of(context)!.oopsSomethingWentWrong,
                textAlign: TextAlign.center,
              ),
            );
          }
          final accounts = snapshot.data;
          if (accounts == null) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (accounts.isEmpty) {
            return Center(
              child: Text(
                L10n.of(context)!.suchEmpty,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, i) => AccountListTile(account: accounts[i]),
          );
        },
      ),
    );
  }
}
