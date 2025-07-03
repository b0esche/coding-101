import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String pw);
  Future<void> createUserWithEmailAndPassword(String email, String pw);
  Future<void> signOut();
  Future<void> signInWithGoogle();
  Stream<User?> authStateChanges();
}
