extension IntShortStringExtension on int {
  String get shortString {
    if (this < 1000) return toString();
    if (this < 1000000) return '${(this / 1000).floor().toString()}k';
    return '${(this / 1000000).floor().toString()}m';
  }
}
