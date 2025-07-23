import 'package:gig_hub/src/Data/app_imports.dart';

class FirebaseAuthRepository implements AuthRepository {
  // sign up w/ email ###
  @override
  Future<void> createUserWithEmailAndPassword(String email, String pw) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pw);
    await userCredential.user?.sendEmailVerification();
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

  // password reset ###
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    final email = await FirebaseAuth.instance.verifyPasswordResetCode(code);
    return email;
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    await FirebaseAuth.instance.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }

  // sign out all ###
  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();
  }

  // delete user and sign out
  @override
  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete().whenComplete(() async {
      await FirebaseAuth.instance.signOut();
    });
  }

  // user stream ###
  @override
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
