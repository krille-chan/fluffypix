import 'account.dart';
import 'status.dart';

class SearchResult {
  final List<Account> accounts;
  final List<Status> statuses;
  final List<Hashtag> hashtags;

  const SearchResult({
    required this.accounts,
    required this.statuses,
    required this.hashtags,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        accounts:
            (json['accounts'] as List).map((i) => Account.fromJson(i)).toList(),
        statuses:
            (json['statuses'] as List).map((i) => Status.fromJson(i)).toList(),
        hashtags:
            (json['hashtags'] as List).map((i) => Hashtag.fromJson(i)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'accounts': accounts.map((i) => i.toJson()).toList(),
        'statuses': statuses.map((i) => i.toJson()).toList(),
        'hashtags': hashtags.map((i) => i.toJson()).toList(),
      };
}

class Hashtag {
  final String name;
  final String url;
  final List<History>? history;

  const Hashtag({
    required this.name,
    required this.url,
    this.history,
  });

  factory Hashtag.fromJson(Map<String, dynamic> json) => Hashtag(
        name: json['name'],
        url: json['url'],
        history: json['history'] == null
            ? null
            : (json['history'] as List)
                .map((i) => History.fromJson(i))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        if (history != null)
          'history': history!.map((i) => i.toJson()).toList(),
      };
}

class History {
  final String day;
  final String uses;
  final String accounts;

  const History({
    required this.day,
    required this.uses,
    required this.accounts,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        day: json['day'],
        uses: json['uses'],
        accounts: json['accounts'],
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'uses': uses,
        'accounts': accounts,
      };
}
