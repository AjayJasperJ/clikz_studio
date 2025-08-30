import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthCredentialProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool googleLoginLoading = false;
  bool emailLoginLoading = false;
  bool _email_register_isloading = false;
  bool get emailRegisterLoading => _email_register_isloading;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    if (googleLoginLoading) return null;
    googleLoginLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        googleLoginLoading = false;
        notifyListeners();
        return null; // User cancelled
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      // Save user info to Firestore if new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final user = userCredential.user;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'Username': user.displayName ?? '',
            'Email': user.email ?? '',
            'Role': 'Member',
            'CreatedAt': FieldValue.serverTimestamp(),
            'profileImage': '',
          });
        }
      }
      googleLoginLoading = false;
      notifyListeners();
      return userCredential;
    } catch (e) {
      googleLoginLoading = false;
      notifyListeners();
      _showError(context, 'Google sign-in failed: $e');
      return null;
    }
  }

  Future<UserCredential?> registerWithEmail({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    String? profileImageBase64,
  }) async {
    _email_register_isloading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await userCredential.user?.updateDisplayName(name.trim());
      await userCredential.user?.reload();
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'Username': name.trim(),
        'Email': email.trim(),
        'Role': 'Member',
        'CreatedAt': FieldValue.serverTimestamp(),
        'profileImage': profileImageBase64 ?? '',
      });
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _showError(context, e.message ?? e.toString());
      return null;
    } finally {
      _email_register_isloading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> loginWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (emailLoginLoading) return null;
    emailLoginLoading = true;
    notifyListeners();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (!credential.user!.emailVerified) {
        await credential.user!.sendEmailVerification();
        _showDialog(
          context,
          'Email not verified',
          'A verification link has been sent to your email. Please verify before logging in.',
        );
        emailLoginLoading = false;
        notifyListeners();
        return null;
      }
      emailLoginLoading = false;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      emailLoginLoading = false;
      notifyListeners();
      _showError(context, e.message ?? 'Unknown error');
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    notifyListeners();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
      ),
    );
  }
}
