class UserModel {
  final String email;
  final String username;
  final String name;
  final String uid;
  final double latitude;
  final double longitude;
  final DateTime lastUpdated;

  const UserModel({
    required this.email,
    required this.name,
    required this.username,
    required this.uid,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        name: json['name'],
        username: json['username'],
        uid: json['uid'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'username': username,
        'uid': uid,
        'latitude': latitude,
        'longitude': longitude,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}
