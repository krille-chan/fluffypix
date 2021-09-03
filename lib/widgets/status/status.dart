import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:badges/badges.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/model/status_visibility.dart';
import 'package:fluffypix/widgets/avatar.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:simple_html_css/simple_html_css.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/int_short_string_extension.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class StatusWidget extends StatefulWidget {
  final Status status;
  final List<Status> replies;
  final bool replyMode;
  final void Function(Status? status, [String? deleteId]) onUpdate;

  const StatusWidget({
    Key? key,
    required this.status,
    required this.onUpdate,
    this.replyMode = false,
    this.replies = const [],
  }) : super(key: key);

  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  bool _favoriteLoading = false;
  bool _shareLoading = false;

  void favoriteAction() async {
    setState(() => _favoriteLoading = true);
    try {
      final status = await (widget.status.favourited ?? false
          ? FluffyPix.of(context).unfavoriteStatus(widget.status.id)
          : FluffyPix.of(context).favoriteStatus(widget.status.id));
      widget.onUpdate(status);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() => _favoriteLoading = false);
    }
  }

  void shareAction() async {
    setState(() => _shareLoading = true);
    try {
      final status = await (widget.status.reblogged ?? false
          ? FluffyPix.of(context).unboostStatus(widget.status.id)
          : FluffyPix.of(context).boostStatus(widget.status.id));
      widget.onUpdate(status);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    } finally {
      setState(() => _shareLoading = false);
    }
  }

  void commentAction() => Navigator.of(context).pushNamed(
        '/status/${widget.status.id}',
        arguments: widget.status,
      );

  void deleteAction() async {
    final confirmed = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.deletePost,
      message: L10n.of(context)!.areYouSure,
      okLabel: L10n.of(context)!.delete,
      isDestructiveAction: true,
      cancelLabel: L10n.of(context)!.cancel,
      fullyCapitalizedForMaterial: false,
    );
    if (confirmed != OkCancelResult.ok) return;
    try {
      final featureController = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.deleting),
        ),
      );
      await FluffyPix.of(context).deleteStatus(widget.status.id);
      featureController.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.postHasBeenDeleted),
        ),
      );
      widget.onUpdate.call(null, widget.status.id);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    }
  }

  void onStatusAction(StatusAction action) {
    switch (action) {
      case StatusAction.shareLink:
        if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
          Share.share(widget.status.uri);
        } else {
          Clipboard.setData(ClipboardData(text: widget.status.uri));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10n.of(context)!.copiedToClipboard),
            ),
          );
        }
        break;
      case StatusAction.open:
        commentAction();
        break;
      case StatusAction.report:
        reportAction();
        break;
      case StatusAction.delete:
        deleteAction();
        break;
    }
  }

  void reportAction() async {
    final comment = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.report,
      message: L10n.of(context)!.reportDescription,
      textFields: [DialogTextField(hintText: L10n.of(context)!.reason)],
    );
    if (comment == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.of(context)!.loading),
      ),
    );
    try {
      await FluffyPix.of(context).report(
        widget.status.account.id,
        [widget.status.id],
        comment.first,
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
      );
      rethrow;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.of(context)!.postHasBeenReported),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgePosition = BadgePosition.topEnd(top: 0, end: 0);
    final author = widget.status.reblog?.account ?? widget.status.account;
    final displayName =
        author.displayName.isEmpty ? author.username : author.displayName;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.status.reblog != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 12,
              right: 12,
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Icon(
                    CupertinoIcons.repeat,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Avatar(account: widget.status.account, radius: 8),
                const SizedBox(width: 4),
                Text(
                  L10n.of(context)!.userShared(
                    widget.status.account.displayName.isNotEmpty
                        ? widget.status.account.displayName
                        : widget.status.account.username,
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ListTile(
          onTap: () => Navigator.of(context).pushNamed('/user/${author.id}'),
          leading: Avatar(account: author),
          title: Text(
            displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '@${author.acct}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.status.visibility.icon,
                size: 16,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
              const SizedBox(width: 4),
              Text(widget.status.createdAt.localizedTimeShort(context)),
            ],
          ),
        ),
        widget.replyMode
            ? Padding(
                padding: const EdgeInsets.only(left: 56.0),
                child: StatusContent(
                  status: widget.status,
                  imageStatusMode: ImageStatusMode.reply,
                ),
              )
            : StatusContent(
                status: widget.status,
                imageStatusMode:
                    widget.status.visibility == StatusVisibility.direct
                        ? ImageStatusMode.reply
                        : ImageStatusMode.timeline,
              ),
        Padding(
          padding: widget.replyMode
              ? const EdgeInsets.only(
                  left: 64.0, right: 8.0, top: 8.0, bottom: 8.0)
              : const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _favoriteLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CupertinoActivityIndicator(),
                    )
                  : Badge(
                      badgeContent: Text(
                        widget.status.favouritesCount.shortString,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.all(2),
                      position: badgePosition,
                      badgeColor: Theme.of(context).appBarTheme.color!,
                      showBadge: widget.status.favouritesCount > 0,
                      child: IconButton(
                        icon: Icon(
                          widget.status.favourited ?? false
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: widget.status.favourited ?? false
                              ? Colors.red
                              : null,
                        ),
                        onPressed: favoriteAction,
                      ),
                    ),
              Badge(
                badgeContent: Text(
                  widget.status.repliesCount.shortString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(6),
                padding: const EdgeInsets.all(2),
                position: badgePosition,
                showBadge: widget.status.repliesCount > 0,
                badgeColor: Theme.of(context).appBarTheme.color!,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chat_bubble),
                  onPressed: commentAction,
                ),
              ),
              _shareLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CupertinoActivityIndicator(),
                    )
                  : Badge(
                      badgeContent: Text(
                        widget.status.reblogsCount.shortString,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.all(2),
                      showBadge: widget.status.reblogsCount > 0,
                      badgeColor: Theme.of(context).appBarTheme.color!,
                      position: badgePosition,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.repeat,
                            color: widget.status.reblogged ?? false
                                ? Colors.green
                                : null),
                        onPressed: shareAction,
                      ),
                    ),
              const Spacer(),
              PopupMenuButton<StatusAction>(
                onSelected: onStatusAction,
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: StatusAction.open,
                    child: Text(L10n.of(context)!.viewPost),
                  ),
                  PopupMenuItem(
                    value: StatusAction.report,
                    child: Text(L10n.of(context)!.report),
                  ),
                  PopupMenuItem(
                    value: StatusAction.shareLink,
                    child: Text(L10n.of(context)!.shareLink),
                  ),
                  if (FluffyPix.of(context).ownAccount!.username ==
                      widget.status.account.username)
                    PopupMenuItem(
                      value: StatusAction.delete,
                      child: Text(
                        L10n.of(context)!.delete,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        for (final reply in widget.replies)
          ListTile(
            onTap: () => Navigator.of(context).pushNamed(
              '/status/${reply.id}',
              arguments: reply,
            ),
            title: RichText(
              text: HTML.toTextSpan(
                context,
                '<b>${reply.account.displayName.isNotEmpty ? reply.account.displayName : reply.account.username}</b>: ${reply.content}',
                defaultTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            ),
          ),
        if (widget.replies.isNotEmpty) const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

enum StatusAction {
  open,
  report,
  delete,
  shareLink,
}
