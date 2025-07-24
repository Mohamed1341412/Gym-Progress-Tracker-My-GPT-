import '../models/friend_model.dart';

class MockDatabase {
  static List<Friend> friends = [
    Friend(name: 'Alice', countryCode: 'US', online: true),
    Friend(name: 'Bob', countryCode: 'GB', online: false),
  ];
  static List<Friend> pendingRequests = [];
} 