import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository implements AuthRepository {
  // sign up w/ email ###

  @override
  Future<void> createUserWithEmailAndPassword(String email, String pw) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pw,
    );
  }

  // sign in w/ email ###

  @override
  Future<void> signInWithEmailAndPassword(String email, String pw) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pw,
    );
  }

  // sign in/up w/ apple ### TODO: impl. APPLE SIGN IN

  @override
  Future<void> signInWithApple() async {
    //
  }

  // sign in/up w/ google ###

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

  // sign in/up w/ facebook ###

  @override
  Future<void> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(
      loginBehavior: LoginBehavior.nativeWithFallback,
    );
    if (result.status == LoginStatus.success && result.accessToken != null) {
      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      throw Exception('Facebook login failed: ${result.status}');
    }
  }

  // sign out all ###

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();
  }

  // user stream ###

  @override
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
