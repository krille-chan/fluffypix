import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffypix/utils/links_callback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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

  void launchUrl(BuildContext context) => isUrl
      ? linksCallback(pureValue, context)
      : showOkAlertDialog(
          context: context,
          title: name,
          message: pureValue,
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
