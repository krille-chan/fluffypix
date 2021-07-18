import 'package:fluffypix/model/status.dart';
import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

class TextStatusContent extends StatelessWidget {
  final Status status;

  const TextStatusContent({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: HTML.toTextSpan(
          context,
          status.content,
        ),
      ),
    );
  }
}
