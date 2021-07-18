import 'package:fluffypix/model/status.dart';
import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';

class TextStatusContent extends StatelessWidget {
  final Status status;

  const TextStatusContent({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SingleChildScrollView(
          child: RichText(
            textAlign: TextAlign.center,
            text: HTML.toTextSpan(
              context,
              status.content,
              linksCallback: (link) => launch(link),
              overrideStyle: {'a': TextStyle(color: Colors.grey[350])},
              defaultTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
