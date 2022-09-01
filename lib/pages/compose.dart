import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:fluffypix/model/account.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status_visibility.dart';
import '../model/fluffy_pix_api_extension.dart';
import '../model/fluffy_pix_upload_extension.dart';
import 'views/compose_view.dart';

class ComposePage extends StatefulWidget {
  final Account? dmUser;
  final String? sharedText;
  final List<SharedMediaFile>? sharedMediaFiles;

  const ComposePage({
    Key? key,
    this.dmUser,
    this.sharedMediaFiles,
    this.sharedText,
  }) : super(key: key);

  @override
  ComposePageController createState() => ComposePageController();
}

class ComposePageController extends State<ComposePage> {
  final TextEditingController statusController = TextEditingController();
  bool sensitive = false;
  StatusVisibility visibility = StatusVisibility.public;
  List<ToUploadFile> media = [];
  bool loading = false;
  bool loadingPhoto = false;

  void toggleSensitive([_]) => setState(() => sensitive = !sensitive);

  void addMedia({bool video = false}) async {
    final source = (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
        ? await showModalActionSheet<ImageSource>(
            context: context,
            title:
                video ? L10n.of(context)!.addVideo : L10n.of(context)!.addPhoto,
            actions: [
              SheetAction(
                label: L10n.of(context)!.openCamera,
                key: ImageSource.camera,
                icon: CupertinoIcons.camera,
              ),
              SheetAction(
                label: L10n.of(context)!.pickFromYourGallery,
                key: ImageSource.gallery,
                icon: CupertinoIcons.photo,
              ),
            ],
          )
        : ImageSource.gallery;
    if (source == null) return;
    setState(() => loadingPhoto = true);
    const maxSize = 2048.0;
    final pick = video
        ? await ImagePicker().pickVideo(
            source: source,
            preferredCameraDevice: CameraDevice.front,
          )
        : await ImagePicker().pickImage(
            source: source,
            maxHeight: maxSize,
            maxWidth: maxSize,
            preferredCameraDevice: CameraDevice.front,
          );
    if (pick != null) {
      final bytes = await pick.readAsBytes();
      setState(() => media.add(ToUploadFile(bytes, pick.name, video: video)));
    }
    setState(() => loadingPhoto = false);
  }

  void removeMedia(int i) => setState(() => media.removeAt(i));

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    sensitive = false;
    statusController.clear();
    if (widget.dmUser != null) {
      statusController.text = '@${widget.dmUser?.acct} ';
    }
    if (widget.sharedText != null) {
      statusController.text = widget.sharedText!;
    }
    if (widget.sharedMediaFiles != null) {
      setState(() => loadingPhoto = true);
      for (final sharedMediaFile in widget.sharedMediaFiles!) {
        try {
          final bytes = await File(sharedMediaFile.path).readAsBytes();
          setState(
            () => media.add(
              ToUploadFile(
                bytes,
                sharedMediaFile.path.split('/').last,
              ),
            ),
          );
        } catch (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10n.of(context)!.oopsSomethingWentWrong),
            ),
          );
        }
      }
      setState(() => loadingPhoto = false);
    }
    visibility = widget.dmUser != null
        ? StatusVisibility.direct
        : StatusVisibility.public;
  }

  void resetAction() => setState(_init);

  void setVisibility() async {
    final newVisibility = await showModalActionSheet(
      context: context,
      title: L10n.of(context)!.visibility,
      message: visibility.toLocalizedString(context),
      actions: StatusVisibility.values
          .map(
            (vis) => SheetAction(
              key: vis,
              label: vis.toLocalizedString(context),
              icon: vis.icon,
              isDefaultAction: vis == visibility,
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
      final mediaIds = <String>[];
      for (final file in media) {
        final result =
            await FluffyPix.of(context).upload(file.bytes, file.filename);
        mediaIds.add(result.id);
      }
      await FluffyPix.of(context).publishNewStatus(
        status: statusController.text,
        sensitive: sensitive,
        visibility: visibility,
        mediaIds: mediaIds,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.newPostPublished),
        ),
      );
      if (visibility == StatusVisibility.direct) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/messages', (route) => route.isFirst);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      }
    } on ServerErrorResponse catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
      rethrow;
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

class ToUploadFile {
  final Uint8List bytes;
  final String filename;
  final bool video;

  ToUploadFile(this.bytes, this.filename, {this.video = false});
}
