import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/search_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class TrendingHashtagsCard extends StatefulWidget {
  const TrendingHashtagsCard({Key? key}) : super(key: key);

  @override
  _TrendingHashtagsCardState createState() => _TrendingHashtagsCardState();
}

class _TrendingHashtagsCardState extends State<TrendingHashtagsCard> {
  static Future<List<Hashtag>>? trendsFuture;

  @override
  Widget build(BuildContext context) {
    trendsFuture ??= FluffyPix.of(context).getTrends();

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
                L10n.of(context)!.trendingHashtags,
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
              child: FutureBuilder<List<Hashtag>>(
                future: trendsFuture,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                        ? snapshot.data?.isEmpty ?? true
                            ? Text(L10n.of(context)!.suchEmpty)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: snapshot.data!
                                    .map(
                                      (tag) => ListTile(
                                        title: Text(
                                          '#${tag.name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/tags/${tag.name}'),
                                      ),
                                    )
                                    .toList(),
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
