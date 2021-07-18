import 'package:fluffypix/config/app_configs.dart';
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
      constraints: BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(12.0),
      color: AppConfigs.primaryColor.withOpacity(0.1),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: HTML.toTextSpan(
            context,
            status.content,
            linksCallback: (link) => launch(link),
            defaultTextStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
