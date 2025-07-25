import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await _saveUser(credential.user!);
    return credential.user;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _saveUser(credential.user!);
    return credential.user;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    await _saveUser(userCredential.user!);
    return userCredential.user;
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Facebook sign in aborted');
    }
    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    final userCredential = await _auth.signInWithCredential(credential);
    await _saveUser(userCredential.user!);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> _saveUser(User user) async {
    final ref =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    await ref.set({
      'name': user.displayName,
      'email': user.email,
      'photo': user.photoURL,
      'provider': user.providerData.first.providerId,
      'updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
} 