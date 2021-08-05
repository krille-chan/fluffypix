import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/login.dart';
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
            final instances = snapshot.data;
            if (instances == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
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
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1)),
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
                  child: ListView.separated(
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Colors.black),
                    itemCount: instances.length,
                    itemBuilder: (context, i) => Container(
                      height: 256,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            instances[i].thumbnail ??
                                'https://cdn.pixabay.com/photo/2018/11/29/21/51/social-media-3846597_960_720.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        color: Colors.black.withOpacity(0.5),
                        child: ListTile(
                          title: Text(
                            instances[i].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            instances[i].shortDescription ?? '',
                            style: TextStyle(color: Colors.grey[100]),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () =>
                                controller.loginAction(instances[i].name),
                            child: const Text('Login'),
                          ),
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
