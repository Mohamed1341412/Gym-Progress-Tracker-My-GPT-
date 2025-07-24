enum FriendStatus { pending, accepted, blocked }

class Friend {
  String uid;
  String name;
  String countryCode; // e.g., 'US', 'EG'
  bool online;
  DateTime lastSeen;
  bool muted;
  bool blocked;
  FriendStatus status;

  Friend({
    required this.uid,
    required this.name,
    required this.countryCode,
    this.online = false,
    DateTime? lastSeen,
    this.muted = false,
    this.blocked = false,
    this.status = FriendStatus.pending,
  }) : lastSeen = lastSeen ?? DateTime.now();

  String get flagEmoji {
    // Basic conversion to regional indicator symbols
    return countryCode.toUpperCase().codeUnits
        .map((c) => String.fromCharCode(0x1F1E6 - 65 + c))
        .join();
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'country': countryCode,
        'online': online,
        'lastSeen': lastSeen.toIso8601String(),
        'muted': muted,
        'blocked': blocked,
        'status': status.index,
      };

  factory Friend.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Friend(
      uid: d['uid'] ?? '',
      name: d['name'] ?? '',
      countryCode: d['country'] ?? 'US',
      online: d['online'] ?? false,
      lastSeen: DateTime.tryParse(d['lastSeen'] ?? '') ?? DateTime.now(),
      muted: d['muted'] ?? false,
      blocked: d['blocked'] ?? false,
      status: FriendStatus.values[d['status'] ?? 0],
    );
  }
} 