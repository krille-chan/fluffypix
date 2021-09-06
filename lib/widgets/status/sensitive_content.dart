import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SensitiveContent extends StatelessWidget {
  final void Function()? onUnlock;
  final String blurHash;
  const SensitiveContent({this.onUnlock, required this.blurHash, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      color: Theme.of(context).secondaryHeaderColor,
      child: Stack(
        children: [
          BlurHash(hash: blurHash),
          Center(
            child: SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.25)),
                onPressed: onUnlock,
                icon: const Icon(
                  CupertinoIcons.lock,
                  color: Colors.white,
                ),
                label: Text(
                  L10n.of(context)!.nsfw,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
