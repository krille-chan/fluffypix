import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/widgets/horizontal_account_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class DiscoverAccountsCard extends StatefulWidget {
  const DiscoverAccountsCard({Key? key}) : super(key: key);

  @override
  _DiscoverAccountsCardState createState() => _DiscoverAccountsCardState();
}

class _DiscoverAccountsCardState extends State<DiscoverAccountsCard> {
  static Future<List<Account>>? trendsFuture;
  @override
  Widget build(BuildContext context) {
    trendsFuture ??= FluffyPix.of(context).getTrendAccounts();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                L10n.of(context)!.discoverUsers,
                style: const TextStyle(fontSize: 24),
              ),
              trailing: IconButton(
                icon: const Icon(CupertinoIcons.refresh_circled),
                onPressed: () => setState(
                  () => trendsFuture = null,
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Account>>(
                future: trendsFuture,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                        ? HorizontalAccountList(
                            accounts: snapshot.data!,
                            onTap: (id) =>
                                Navigator.of(context).pushNamed('/user/$id'),
                          )
                        : const Center(child: CupertinoActivityIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
