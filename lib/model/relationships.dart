class Relationships {
  final String? id;
  final bool? following;
  final bool? showingReblogs;
  final bool? notifying;
  final bool? followedBy;
  final bool? blocking;
  final bool? blockedBy;
  final bool? muting;
  final bool? mutingNotifications;
  final bool? requested;
  final bool? domainBlocking;
  final bool? endorsed;

  const Relationships({
    this.id,
    this.following,
    this.showingReblogs,
    this.notifying,
    this.followedBy,
    this.blocking,
    this.blockedBy,
    this.muting,
    this.mutingNotifications,
    this.requested,
    this.domainBlocking,
    this.endorsed,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        id: json['id'],
        following: json['following'],
        showingReblogs: json['showing_reblogs'],
        notifying: json['notifying'],
        followedBy: json['followed_by'],
        blocking: json['blocking'],
        blockedBy: json['blocked_by'],
        muting: json['muting'],
        mutingNotifications: json['muting_notifications'],
        requested: json['requested'],
        domainBlocking: json['domain_blocking'],
        endorsed: json['endorsed'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (following != null) 'following': following,
        if (showingReblogs != null) 'showing_reblogs': showingReblogs,
        if (notifying != null) 'notifying': notifying,
        if (followedBy != null) 'followed_by': followedBy,
        if (blocking != null) 'blocking': blocking,
        if (blockedBy != null) 'blocked_by': blockedBy,
        if (muting != null) 'muting': muting,
        if (mutingNotifications != null)
          'muting_notifications': mutingNotifications,
        if (requested != null) 'requested': requested,
        if (domainBlocking != null) 'domain_blocking': domainBlocking,
        if (endorsed != null) 'endorsed': endorsed,
      };
}
