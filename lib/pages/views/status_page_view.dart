import 'package:fluffypix/pages/status.dart';
import 'package:fluffypix/widgets/nav_scaffold.dart';
import 'package:fluffypix/widgets/status/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class StatusPageView extends StatelessWidget {
  final StatusPageController controller;
  const StatusPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavScaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.viewPost)),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        onRefresh: controller.refresh,
        child: ListView(
          physics: controller.scrollPhysics,
          controller: controller.scrollController,
          children: [
            if (controller.statusContext != null)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(
                    parent: controller.scrollPhysics),
                itemCount: controller.statusContext!.ancestors.length,
                itemBuilder: (context, i) => StatusWidget(
                  status: controller.statusContext!.ancestors[i],
                  onUpdate: controller.onUpdateStatus,
                  replyMode: true,
                ),
              ),
            if (controller.status != null) ...[
              StatusWidget(
                status: controller.status!,
                onUpdate: controller.onUpdateStatus,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: controller.textEditingController,
                  focusNode: controller.focusNode,
                  minLines: 5,
                  maxLines: 8,
                  maxLength: 500,
                  readOnly: controller.commentLoading,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    hintText: L10n.of(context)!.comment,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 42,
                child: ElevatedButton.icon(
                  icon: const Icon(CupertinoIcons.chat_bubble),
                  label: controller.commentLoading
                      ? const CupertinoActivityIndicator()
                      : Text(L10n.of(context)!.sendComment),
                  onPressed: controller.commentLoading
                      ? null
                      : controller.commentAction,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
            ],
            if (controller.statusContext != null) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(
                    parent: controller.scrollPhysics),
                itemCount: controller.statusContext!.descendants.length,
                itemBuilder: (context, i) => StatusWidget(
                  status: controller.statusContext!.descendants[i],
                  onUpdate: controller.onUpdateStatus,
                  replyMode: true,
                ),
              ),
            ],
          ],
        ),
      ),
      scrollController: controller.scrollController,
    );
  }
}
