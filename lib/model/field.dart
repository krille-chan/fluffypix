import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffypix/utils/links_callback.dart';

class Field {
  final String name;
  final String value;
  final String? verifiedAt;

  const Field({
    required this.name,
    required this.value,
    this.verifiedAt,
  });

  bool get isUrl => Uri.tryParse(pureValue) != null;

  void launchUrl(BuildContext context) =>
      isUrl && Uri.parse(pureValue).isAbsolute
          ? linksCallback(pureValue, context)
          : showOkAlertDialog(
              context: context,
              title: name,
              message: Uri.decodeFull(pureValue),
              okLabel: L10n.of(context)!.close,
            );

  String get pureValue => value.replaceAll(RegExp(r'<[^>]*>'), '');

  String get displayText => isUrl ? name : '$name: $value';

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        name: json['name'],
        value: json['value'],
        verifiedAt: json['verified_at'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        if (verifiedAt != null) 'verified_at': verifiedAt,
      };
}
