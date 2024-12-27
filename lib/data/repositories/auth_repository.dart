import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Pour `kIsWeb`


class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.userChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() =>
      _auth.signInWithProvider(GoogleAuthProvider());

  Future<void> signOut() {
    return _auth.signOut();
  }
}