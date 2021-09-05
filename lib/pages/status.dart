import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/model/status_context.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../model/fluffy_pix_api_extension.dart';

import 'views/status_page_view.dart';

class StatusPage extends StatefulWidget {
  final String statusId;
  final Status? status;
  const StatusPage({
    required this.statusId,
    this.status,
    Key? key,
  }) : super(key: key);

  @override
  StatusPageController createState() => StatusPageController();
}

class StatusPageController extends State<StatusPage> {
  final ScrollPhysics scrollPhysics = const ScrollPhysics();
  Status? status;
  StatusContext? statusContext;
  final TextEditingController textEditingController = TextEditingController();
  bool commentLoading = false;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  void refresh() async {
    try {
      status ??= await FluffyPix.of(context).getStatus(widget.statusId);
      statusContext =
          await FluffyPix.of(context).getStatusContext(widget.statusId);
      setState(() {});
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
      rethrow;
    }
  }

  void onUpdateStatus(Status? status, [String? deleteId]) {
    if (status == null) {
      if (deleteId == this.status?.id) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
      setState(() {
        statusContext?.ancestors.removeWhere((s) => s.id == deleteId);
        statusContext?.descendants.removeWhere((s) => s.id == deleteId);
      });
      return;
    }
    setState(() {
      if (this.status?.id == status.id ||
          this.status?.reblog?.id == status.id) {
        this.status = status;
      } else {
        statusContext?.ancestors[statusContext!.ancestors.indexWhere(
            (s) => s.id == status.id || s.reblog?.id == status.id)] = status;
        statusContext?.descendants[statusContext!.descendants.indexWhere(
            (s) => s.id == status.id || s.reblog?.id == status.id)] = status;
      }
    });
  }

  void commentAction() async {
    if (textEditingController.text.isEmpty) {
      return;
    }
    setState(() => commentLoading = true);
    try {
      await FluffyPix.of(context).publishNewStatus(
        status: textEditingController.text,
        visibility: status!.visibility,
        inReplyTo: status!.id,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.newPostPublished),
        ),
      );
      textEditingController.clear();
      focusNode.unfocus();
      refreshController.requestRefresh();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() => commentLoading = false);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StatusPageView(this);
}
