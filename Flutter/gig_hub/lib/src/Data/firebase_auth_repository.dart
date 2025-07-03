import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<void> createUserWithEmailAndPassword(String email, String pw) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pw,
    );
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String pw) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pw,
    );
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  @override
  Future<void> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize();
    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
