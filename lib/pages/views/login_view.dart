import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:fluffypix/widgets/instance_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LoginPageView extends StatelessWidget {
  final LoginPageController controller;
  const LoginPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context)!.pickACommunity),
      ),
      body: FutureBuilder<List<PublicInstance>>(
          future: controller.publicInstancesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(L10n.of(context)!.oopsSomethingWentWrong),
              );
            }
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final instances = snapshot.data ?? [];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    right: 12,
                    left: 12,
                  ),
                  child: Center(
                      child: Text(
                    L10n.of(context)!.pickACommunityDescription,
                    textAlign: TextAlign.center,
                  )),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: controller.searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: controller.searchQueryWithCooldown,
                      onSubmitted: isLoading ? null : controller.searchQuery,
                      decoration: InputDecoration(
                        suffixIcon: isLoading
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(CupertinoIcons.search),
                                onPressed: controller.searchQuery,
                              ),
                        hintText: L10n.of(context)!.search,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      left: 12.0,
                      right: 12.0,
                    ),
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 32),
                        separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color:
                                Theme.of(context).textTheme.bodyText1?.color),
                        itemCount: instances.length,
                        itemBuilder: (context, i) => InstanceListItem(
                          instance: instances[i],
                          controller: controller,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
