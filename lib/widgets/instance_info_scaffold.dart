import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/config/app_configs.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/date_time_extension.dart';

class InstanceInfoScaffold extends StatelessWidget {
  final PublicInstance instance;
  const InstanceInfoScaffold({required this.instance, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(instance.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              child: Text(L10n.of(context)!.website),
              onPressed: () => launch(instance.name),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 256,
            child: CachedNetworkImage(
              imageUrl: instance.thumbnail ?? '',
              progressIndicatorBuilder: (context, s, p) =>
                  const Center(child: CupertinoActivityIndicator()),
              fit: BoxFit.cover,
              height: double.infinity,
              errorWidget: (_, __, ___) =>
                  const BlurHash(hash: AppConfigs.fallbackBlurHash),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: Text(instance.name),
            subtitle: Text(instance.fullDescription ??
                instance.shortDescription ??
                L10n.of(context)!.unknown),
          ),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: Text(L10n.of(context)!.admin),
            subtitle: Text(instance.admin ?? L10n.of(context)!.unknown),
          ),
          ListTile(
            leading: const Icon(Icons.people_outlined),
            title: Text(L10n.of(context)!.users),
            subtitle: Text(instance.users ?? L10n.of(context)!.unknown),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(L10n.of(context)!.statuses),
            subtitle: Text(instance.statuses ?? L10n.of(context)!.unknown),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(L10n.of(context)!.addedAt),
            subtitle: Text(instance.addedAt?.localizedTime(context) ??
                L10n.of(context)!.unknown),
          ),
          ListTile(
            leading: const Icon(Icons.domain_outlined),
            title: Text(L10n.of(context)!.serverVersion),
            subtitle: Text(instance.version ?? L10n.of(context)!.unknown),
          ),
        ],
      ),
    );
  }
}
