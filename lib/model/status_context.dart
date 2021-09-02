import 'package:fluffypix/model/status.dart';

class StatusContext {
  final List<Status> ancestors;
  final List<Status> descendants;

  const StatusContext({
    required this.ancestors,
    required this.descendants,
  });

  factory StatusContext.fromJson(Map<String, dynamic> json) => StatusContext(
        ancestors:
            (json['ancestors'] as List).map((i) => Status.fromJson(i)).toList(),
        descendants: (json['descendants'] as List)
            .map((i) => Status.fromJson(i))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'ancestors': ancestors.map((i) => i.toJson()).toList(),
        'descendants': descendants.map((i) => i.toJson()).toList(),
      };
}
