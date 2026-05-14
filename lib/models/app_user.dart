// models/app_user.dart
// Represents the signed-in user profile data

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? city;
  final String? zip;
  final String? avatarUrl;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.city,
    this.zip,
    this.avatarUrl,
  });

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? zip,
    String? avatarUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString(),
      address: map['address']?.toString(),
      city: map['city']?.toString(),
      zip: map['zip']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'zip': zip,
      'avatarUrl': avatarUrl,
    };
  }
}