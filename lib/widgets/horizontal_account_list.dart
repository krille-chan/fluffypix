import 'package:flutter/material.dart';

import 'package:fluffypix/model/account.dart';
import 'avatar.dart';

class HorizontalAccountList extends StatelessWidget {
  final void Function(String) onTap;
  final List<Account> accounts;
  const HorizontalAccountList({
    required this.accounts,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: accounts.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onTap(accounts[i].id),
            child: SizedBox(
              width: 90,
              height: 105,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(64),
                    elevation: 2,
                    child: Avatar(
                      account: accounts[i],
                      radius: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accounts[i].displayName.isNotEmpty
                        ? accounts[i].displayName
                        : accounts[i].username,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
