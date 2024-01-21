import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? user;

  Future signInAnonymously() async {
    UserCredential result = await _auth.signInAnonymously();
    user = result.user;
    return user;
  }

  Future signInWithMail(
      BuildContext context, String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      return user;
    } on FirebaseAuthException catch (e, _) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid Email or Password!"),
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future signUpWithMail(
      BuildContext context, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user = result.user;
      user?.sendEmailVerification();

      return user;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  static String? getEmailOfCurrentUser() {
    return user?.email;
  }
}
