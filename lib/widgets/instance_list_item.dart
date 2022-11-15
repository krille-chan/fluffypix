import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/login.dart';

class InstanceListItem extends StatefulWidget {
  final PublicInstance instance;
  final LoginPageController controller;
  const InstanceListItem(
      {required this.instance, required this.controller, Key? key})
      : super(key: key);

  @override
  _InstanceListItemState createState() => _InstanceListItemState();
}

class _InstanceListItemState extends State<InstanceListItem> {
  bool _loginLoading = false;

  void _loginAction() async {
    setState(() => _loginLoading = true);
    try {
      await widget.controller.loginAction(widget.instance.name);
    } finally {
      setState(() => _loginLoading = false);
    }
  }

  Widget _placeholderBuilder(_, __, [___]) => Image.asset(
        'assets/images/banner.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );

  @override
  Widget build(BuildContext context) {
    final description = widget.instance.shortDescription ??
        widget.instance.fullDescription ??
        '-';
    return InkWell(
      onTap: () => widget.controller.visitInstance(widget.instance),
      child: SizedBox(
        height: 256,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.instance.thumbnail ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: _placeholderBuilder,
              errorWidget: _placeholderBuilder,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Material(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
                child: ListTile(
                  title: Text(
                    widget.instance.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${L10n.of(context)!.members}: ${widget.instance.users ?? L10n.of(context)!.unknown}\n$description',
                    maxLines: 3,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: _loginLoading ? null : _loginAction,
                    child: _loginLoading
                        ? const CupertinoActivityIndicator()
                        : Text(L10n.of(context)!.pick),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
