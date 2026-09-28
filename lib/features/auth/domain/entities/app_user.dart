import 'user_role.dart';

class AppUser {
  final String uid;
  final String email;
  final String? username;
  final UserRole role;

  AppUser({
    required this.uid,
    required this.email,
    this.username,
    this.role = UserRole.paciente,
  });

  AppUser.fromJson(Map<String, dynamic> json)
    : uid = json['uid'],
      email = json['email'],
      username = json['username'] ?? '',
      role = json['role'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'username': username,
    'role': role,
  };
}
