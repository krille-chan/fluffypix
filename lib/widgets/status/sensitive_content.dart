import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SensitiveContent extends StatelessWidget {
  final void Function()? onUnlock;
  const SensitiveContent({this.onUnlock, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      color: Theme.of(context).secondaryHeaderColor,
      alignment: Alignment.center,
      child: SizedBox(
        height: 48,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
          onPressed: onUnlock,
          icon: const Icon(CupertinoIcons.lock),
          label: Text(L10n.of(context)!.nsfw),
        ),
      ),
    );
  }
}
