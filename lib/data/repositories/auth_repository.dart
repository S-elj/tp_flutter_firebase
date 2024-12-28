import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<User?> get authStateChanges => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() =>
      _auth.signInWithProvider(GoogleAuthProvider());

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> uploadAvatar(File imageFile) async {
    if (currentUser == null) throw Exception('Utilisateur non connecté');

    final storageRef =
        _storage.ref().child('avatars/${currentUser!.uid}/profile.jpg');

    try {
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      await currentUser!.updateProfile(photoURL: downloadUrl);

      return downloadUrl;
    } catch (e) {
      throw Exception('Erreur lors du téléchargement de l\'avatar: $e');
    }
  }

  Future<void> deleteAvatar() async {
    if (currentUser?.photoURL == null) return;

    try {
      final storageRef = _storage.refFromURL(currentUser!.photoURL!);
      await storageRef.delete();
      await currentUser!.updateProfile(photoURL: null);
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'avatar: $e');
    }
  }
}
