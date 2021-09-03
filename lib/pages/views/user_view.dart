import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:fluffypix/widgets/avatar.dart';
import 'package:fluffypix/widgets/default_bottom_navigation_bar.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:fluffypix/widgets/status/status_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../utils/int_short_string_extension.dart';

import '../user.dart';

class UserPageView extends StatelessWidget {
  final UserPageController controller;
  const UserPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.profile),
        actions: [
          if (!controller.isOwnUser)
            IconButton(
              onPressed: controller.sendMessage,
              icon: const Icon(CupertinoIcons.mail),
            ),
        ],
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: controller.timeline?.isNotEmpty ?? false,
        onRefresh: controller.refresh,
        onLoading: controller.loadMore,
        child: ListView(
          physics: controller.scrollPhysics,
          controller: controller.scrollController,
          children: [
            if (controller.account != null) ...[
              if (!controller.account!.header.endsWith('missing.png'))
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 256),
                  child: CachedNetworkImage(
                    imageUrl: FluffyPix.of(context).allowAnimatedAvatars
                        ? controller.account!.header
                        : controller.account!.headerStatic,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(48),
                      elevation: 5,
                      child: Avatar(
                        account: controller.account!,
                        radius: 48,
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.account!.displayName.isNotEmpty
                                ? controller.account!.displayName
                                : controller.account!.username,
                            style: const TextStyle(fontSize: 24),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('@${controller.account?.acct}'),
                          const SizedBox(height: 16),
                          if (controller.isOwnUser)
                            OutlinedButton.icon(
                              icon: const Icon(CupertinoIcons.settings),
                              label: Text(L10n.of(context)!.settings),
                              onPressed: controller.goToSettings,
                            ),
                          if (!controller.isOwnUser)
                            controller.relationships == null ||
                                    controller.loadFollowChanges
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 42.0),
                                    child: CupertinoActivityIndicator(),
                                  )
                                : (controller.relationships!.following ?? false)
                                    ? OutlinedButton.icon(
                                        onPressed: controller.unfollow,
                                        icon: const Icon(CupertinoIcons
                                            .square_favorites_alt),
                                        label:
                                            Text(L10n.of(context)!.following),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: controller.follow,
                                        icon: const Icon(CupertinoIcons
                                            .square_favorites_alt_fill),
                                        label: Text(L10n.of(context)!.follow),
                                      ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.account?.fields != null) ...{
                for (final field in controller.account!.fields!)
                  ListTile(
                    onTap: field.isUrl ? field.launchUrl : null,
                    title: Text(
                      field.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      field.pureValue,
                      style: TextStyle(
                        color:
                            field.isUrl ? Theme.of(context).primaryColor : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: field.verifiedAt != null
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
              },
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CountButton(
                      count: controller.account!.statusesCount ?? 0,
                      title: L10n.of(context)!.statuses,
                      onTap: controller.setColumnStatuses,
                      selected: controller.column == UserViewColumn.statuses,
                    ),
                    _CountButton(
                      count: controller.account!.followersCount ?? 0,
                      title: L10n.of(context)!.followers,
                      onTap: controller.setColumnFollowers,
                      selected: controller.column == UserViewColumn.followers,
                    ),
                    _CountButton(
                      count: controller.account!.followingCount ?? 0,
                      title: L10n.of(context)!.following,
                      selected: controller.column == UserViewColumn.following,
                      onTap: controller.setColumnFollowing,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (controller.column == UserViewColumn.statuses) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          controller.userStatusesView == UserStatusesView.grid
                              ? CupertinoIcons.square_grid_3x2_fill
                              : CupertinoIcons.square_grid_3x2,
                        ),
                        onPressed: controller.setStatusesGridView,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          controller.userStatusesView ==
                                  UserStatusesView.timeline
                              ? Icons.view_day
                              : Icons.view_day_outlined,
                        ),
                        onPressed: controller.setStatusesTimelineView,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (controller.timeline != null) ...{
                  if (controller.timeline!.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(L10n.of(context)!.suchEmpty),
                      ),
                    ),
                  if (controller.timeline!.isNotEmpty)
                    controller.userStatusesView == UserStatusesView.grid
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(
                                parent: controller.scrollPhysics),
                            controller: controller.scrollController,
                            itemCount: controller.timeline!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, i) => StatusContent(
                              status: controller.timeline![i],
                              imageStatusMode: ImageStatusMode.discover,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(
                                parent: controller.scrollPhysics),
                            controller: controller.scrollController,
                            itemCount: controller.timeline!.length,
                            itemBuilder: (context, i) => StatusWidget(
                              status: controller.timeline![i],
                              onUpdate: controller.onUpdateStatus,
                            ),
                          ),
                },
                if (controller.timeline == null)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CupertinoActivityIndicator(),
                  )),
              ],
              if (controller.column == UserViewColumn.followers) ...[
                if (controller.followers == null)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CupertinoActivityIndicator(),
                  )),
                if (controller.followers != null) ...{
                  if (controller.followers!.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(L10n.of(context)!.suchEmpty),
                      ),
                    ),
                  if (controller.followers!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(
                          parent: controller.scrollPhysics),
                      controller: controller.scrollController,
                      itemCount: controller.followers?.length,
                      itemBuilder: (context, i) => ListTile(
                        onTap: () =>
                            controller.goToProfile(controller.followers![i].id),
                        leading: Avatar(account: controller.followers![i]),
                        title: Text(controller.followers![i].displayName),
                        subtitle: Text('@${controller.followers![i].acct}'),
                        trailing: const Icon(CupertinoIcons.right_chevron),
                      ),
                    ),
                },
              ],
              if (controller.column == UserViewColumn.following) ...[
                if (controller.following == null)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CupertinoActivityIndicator(),
                  )),
                if (controller.following != null) ...{
                  if (controller.following!.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(L10n.of(context)!.suchEmpty),
                      ),
                    ),
                  if (controller.following!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(
                          parent: controller.scrollPhysics),
                      controller: controller.scrollController,
                      itemCount: controller.following?.length,
                      itemBuilder: (context, i) => ListTile(
                        onTap: () =>
                            controller.goToProfile(controller.following![i].id),
                        leading: Avatar(account: controller.following![i]),
                        title: Text(controller.following![i].displayName),
                        subtitle: Text('@${controller.following![i].acct}'),
                        trailing: const Icon(CupertinoIcons.right_chevron),
                      ),
                    ),
                },
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: DefaultBottomBar(
        currentIndex: controller.isOwnUser ? 4 : null,
        scrollController: controller.scrollController,
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  final String title;
  final int count;
  final void Function() onTap;
  final bool selected;

  const _CountButton({
    required this.title,
    required this.count,
    required this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: selected ? Theme.of(context).secondaryHeaderColor : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.shortString,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
