import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
  bool _expanded = false;
  bool _loginLoading = false;

  void _loginAction() async {
    setState(() => _loginLoading = true);
    await widget.controller.loginAction(widget.instance.name);
    setState(() => _loginLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final description = _expanded
        ? '${widget.instance.shortDescription ?? '-'}\n${widget.instance.fullDescription ?? '-'}'
        : widget.instance.shortDescription ??
            widget.instance.fullDescription ??
            '-';
    return InkWell(
      onTap: () => widget.controller.visitInstance(widget.instance.name),
      child: Container(
        height: 256,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              widget.instance.thumbnail ??
                  'https://cdn.pixabay.com/photo/2018/11/29/21/51/social-media-3846597_960_720.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.white.withOpacity(0.9),
          child: ListTile(
            onTap: () => setState(() => _expanded = !_expanded),
            title: Text(
              widget.instance.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${L10n.of(context)!.members}: ${widget.instance.users ?? L10n.of(context)!.unknown}\n$description',
              maxLines: _expanded ? 10 : 3,
            ),
            trailing: ElevatedButton(
              onPressed: _loginLoading ? null : _loginAction,
              child: _loginLoading
                  ? const CupertinoActivityIndicator()
                  : const Text('Login'),
            ),
          ),
        ),
      ),
    );
  }
}
