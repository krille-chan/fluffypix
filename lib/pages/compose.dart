import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

import 'views/compose_view.dart';

class ComposePage extends StatefulWidget {
  final Account? dmUser;
  const ComposePage({
    Key? key,
    this.dmUser,
  }) : super(key: key);

  @override
  ComposePageController createState() => ComposePageController();
}

class ComposePageController extends State<ComposePage> {
  final TextEditingController statusController = TextEditingController();
  bool sensitive = false;
  StatusVisibility visibility = StatusVisibility.public;
  bool loading = false;
  bool loadingPhoto = false;
  List<Uint8List> media = [];

  void toggleSensitive([_]) => setState(() => sensitive = !sensitive);

  void addMedia() async {
    setState(() => loadingPhoto = true);
    final pick = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 2048,
      maxWidth: 2048,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pick != null) {
      final bytes = await pick.readAsBytes();
      setState(() => media.add(bytes));
    }
    setState(() => loadingPhoto = false);
  }

  void removeMedia(int i) => setState(() => media.removeAt(i));

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    sensitive = false;
    statusController.clear();
    if (widget.dmUser != null) {
      statusController.text = '@${widget.dmUser?.acct} ';
    }
    visibility = widget.dmUser != null
        ? StatusVisibility.direct
        : StatusVisibility.public;
  }

  void resetAction() => setState(_init);

  void setVisibility() async {
    final newVisibility = await showConfirmationDialog(
      context: context,
      title: L10n.of(context)!.visibility,
      message: visibility.toLocalizedString(context),
      actions: StatusVisibility.values
          .map(
            (vis) => AlertDialogAction(
              key: vis,
              label: vis.toLocalizedString(context),
            ),
          )
          .toList(),
    );
    if (newVisibility == null) return;
    setState(() => visibility = newVisibility);
  }

  void postAction() async {
    if (statusController.text.isEmpty && media.isEmpty) {
      return;
    }
    setState(() => loading = true);
    try {
      await FluffyPix.of(context).publishNewStatus(
        status: statusController.text,
        sensitive: sensitive,
        visibility: visibility,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.newPostPublished),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => ComposePageView(this);
}
