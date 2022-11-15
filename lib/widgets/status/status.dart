import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_matrix_html/flutter_html.dart';
import 'package:share/share.dart';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/model/status.dart';
import 'package:fluffypix/model/status_visibility.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:fluffypix/widgets/avatar.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import '../../model/fluffy_pix_api_extension.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/int_short_string_extension.dart';

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

  Status get contentStatus => widget.status.reblog ?? widget.status;

  void favoriteAction() async {
    setState(() => _favoriteLoading = true);
    try {
      final status = await (contentStatus.favourited ?? false
          ? FluffyPix.of(context).unfavoriteStatus(contentStatus.id)
          : FluffyPix.of(context).favoriteStatus(contentStatus.id));
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
      final status = await (contentStatus.reblogged ?? false
          ? FluffyPix.of(context).unboostStatus(contentStatus.id)
          : FluffyPix.of(context).boostStatus(contentStatus.id));
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
        '/status/${(contentStatus).id}',
        arguments: contentStatus,
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
      widget.onUpdate(null, widget.status.id);
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
          Share.share(contentStatus.uri);
        } else {
          Clipboard.setData(ClipboardData(text: contentStatus.uri));
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
      case StatusAction.sharedBy:
        Navigator.of(context).pushNamed('/status/${contentStatus.id}/sharedby');
        break;
      case StatusAction.likedBy:
        Navigator.of(context).pushNamed('/status/${contentStatus.id}/likedby');
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
          leading: InkWell(
            borderRadius: BorderRadius.circular(64),
            onTap: () => Navigator.of(context)
                .pushNamed('/user/${contentStatus.account.id}'),
            child: Avatar(account: contentStatus.account),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  contentStatus.account.calcedDisplayname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                contentStatus.createdAt.localizedTimeShort(context),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  '@${contentStatus.account.acct}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                contentStatus.visibility.icon,
                size: 16,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
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
                        contentStatus.favouritesCount.shortString,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.all(2),
                      position: badgePosition,
                      badgeColor: Colors.red[700]!,
                      showBadge: contentStatus.favouritesCount > 0,
                      child: IconButton(
                        icon: Icon(
                          contentStatus.favourited ?? false
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: contentStatus.favourited ?? false
                              ? Colors.red
                              : null,
                        ),
                        onPressed: favoriteAction,
                      ),
                    ),
              Badge(
                badgeContent: Text(
                  contentStatus.repliesCount.shortString,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(6),
                padding: const EdgeInsets.all(2),
                position: badgePosition,
                showBadge: contentStatus.repliesCount > 0,
                badgeColor: Colors.orange[700]!,
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
                        contentStatus.reblogsCount.shortString,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding: const EdgeInsets.all(2),
                      showBadge: contentStatus.reblogsCount > 0,
                      badgeColor: Colors.green[700]!,
                      position: badgePosition,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.repeat,
                            color: contentStatus.reblogged ?? false
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
                  if (contentStatus.reblogsCount > 0)
                    PopupMenuItem(
                      value: StatusAction.sharedBy,
                      child: Text(L10n.of(context)!.wasSharedBy),
                    ),
                  if (contentStatus.favouritesCount > 0)
                    PopupMenuItem(
                      value: StatusAction.likedBy,
                      child: Text(L10n.of(context)!.wasLikedBy),
                    ),
                  if (FluffyPix.of(context).ownAccount!.id ==
                      widget.status.account.id)
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
            subtitle: Html(
              data:
                  '<b>${reply.account.displayName.isNotEmpty ? reply.account.displayName : reply.account.username}</b>: ${reply.content}',
              onLinkTap: (link) => linksCallback(link, context),
              defaultTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
              linkStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        if (widget.replies.isNotEmpty) const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

enum StatusAction { open, report, delete, shareLink, sharedBy, likedBy }
