enum FriendStatus { pending, accepted, blocked }

class Friend {
  String name;
  String countryCode; // e.g., 'US', 'EG'
  bool online;
  DateTime lastSeen;
  bool muted;
  bool blocked;
  FriendStatus status;

  Friend({
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
} 