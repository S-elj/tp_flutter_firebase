import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tp_flutter_firebase/data/repositories/auth_repository.dart';


class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  Error? error;

  AuthProvider(this._repository) {
    _repository.signOut(); // Déconnecte l'utilisateur au lancement (pour les tests)
    _repository.authStateChanges.listen(
            (_) => notifyListeners(),
        onError: (error) {
          this.error = error;
          notifyListeners();
        }
    );
  }
  bool get isLoggedIn {
    print("Current user: ${_repository.currentUser}");
    return _repository.currentUser != null;
  }

  Future<void> signInWithGoogle() async {
    await _repository.signInWithGoogle();
  }
}