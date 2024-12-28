import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final User? user;
  final String? avatarUrl;

  const AuthModel({
    this.user,
    this.avatarUrl,
  });

  AuthModel copyWith({
    User? user,
    String? avatarUrl,
  }) {
    return AuthModel(
      user: user ?? this.user,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}