// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexstream/presentation/auth_screens/login/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  Future<User?> register(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  Future<void> signOut(BuildContext ctx, String videoId) async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (context) => LoginPage(videoId: videoId),
        ),
        (route) => false,
      );
    } catch (e) {
      print('Sign Out Error: $e');
      throw e;
    }
  }

  User? get currentUser => _auth.currentUser;
}
