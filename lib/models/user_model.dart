class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final int? age;
  final double? height;
  final double? weight;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.age,
    this.height,
    this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      age: map['age'] as int?,
      height: (map['height'] as num?)?.toDouble(),
      weight: (map['weight'] as num?)?.toDouble(),
    );
  }
} 