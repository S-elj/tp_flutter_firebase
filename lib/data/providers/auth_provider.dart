import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tp_flutter_firebase/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  Error? error;

  AuthProvider(this._repository) {
    //_repository.signOut(); // Déconnecte l'utilisateur au lancement (pour les tests)
    _repository.authStateChanges.listen((_) => notifyListeners(),
        onError: (error) {
      this.error = error;
      notifyListeners();
    });
  }

  bool get isLoggedIn {
    print("Current user: ${_repository.currentUser}");
    return _repository.currentUser != null;
  }

  Future<void> signInWithGoogle() async {
    await _repository.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _repository.signUpWithEmail(email, password);
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _repository.signInWithEmail(email, password);
  }

  Future<void> resetPassword(String email) async {
    await _repository.sendPasswordResetEmail(email);
  }

  Future<void> updateAvatar(File imageFile) async {
    try {
      final downloadUrl = await _repository.uploadAvatar(imageFile);
      notifyListeners();
    } catch (e) {
      error = e as Error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeAvatar() async {
    try {
      await _repository.deleteAvatar();
      notifyListeners();
    } catch (e) {
      error = e as Error;
      notifyListeners();
      rethrow;
    }
  }
}
