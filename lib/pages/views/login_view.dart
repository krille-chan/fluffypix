import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffypix/model/public_instance.dart';
import 'package:fluffypix/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;
  const LoginView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context)!.pickACommunity),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: controller.searchQuery,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search_outlined),
                  hintText: L10n.of(context)!.search,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PublicInstance>>(
              future: controller.publicInstancesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(L10n.of(context)!.oopsSomethingWentWrong),
                  );
                }
                final instances = snapshot.data;
                if (instances == null) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.black),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          instances[i].shortDescription ?? '',
                          style: TextStyle(color: Colors.grey[100]),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => null,
                          child: Text('Login'),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
