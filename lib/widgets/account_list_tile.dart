import 'package:fluffypix/model/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'avatar.dart';

class AccountListTile extends StatelessWidget {
  final Account account;
  const AccountListTile({required this.account, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed('/user/${account.id}'),
      leading: Avatar(account: account),
      title: Text(account.calcedDisplayname),
      subtitle: Text('@${account.acct}'),
      trailing: const Icon(CupertinoIcons.right_chevron),
    );
  }
}
