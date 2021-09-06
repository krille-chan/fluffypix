import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum StatusVisibility {
  public,
  unlisted,
  private,
  direct,
}

extension StatusVisibilityLocalization on StatusVisibility {
  IconData get icon {
    switch (this) {
      case StatusVisibility.public:
        return Icons.public_outlined;
      case StatusVisibility.unlisted:
        return Icons.lock_open_outlined;
      case StatusVisibility.private:
        return Icons.lock_open;
      case StatusVisibility.direct:
        return CupertinoIcons.mail;
    }
  }

  String toLocalizedString(BuildContext context) {
    switch (this) {
      case StatusVisibility.public:
        return L10n.of(context)!.worldWide;
      case StatusVisibility.unlisted:
        return L10n.of(context)!.notListed;
      case StatusVisibility.private:
        return L10n.of(context)!.followersOnly;
      case StatusVisibility.direct:
        return L10n.of(context)!.mentionsOnly;
    }
  }
}
