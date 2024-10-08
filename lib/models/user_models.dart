class UserModel {
  final String email;
  final String username;
  final String name;
  final String uid; // Add the uid field here

  const UserModel({
    required this.email,
    required this.name,
    required this.username,
    required this.uid, // Include it in the constructor
  });

  // Modify the fromJson factory to correctly parse the uid from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        name: json['name'],
        username: json['username'],
        uid: json['uid'], // Correctly assign uid from JSON
      );

  // Ensure uid is included in the toJson method
  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'username': username,
        'uid': uid, // Include uid in the JSON representation
      };
}
