import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authservice = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Signup
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    //save user info to firestore
    if (userCredential.user != null) {
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
    return userCredential;
  }

  // Reset Password with Email
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Update Username
  Future<void> updateUsername({required String userName}) async {
    await currentUser!.updateDisplayName(userName);

    // update firestore
    await _firestore.collection("users").doc(currentUser!.uid).update({
      "name": userName,
    });
  }

  // Signout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Delete Account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);

    // Delete from firestore
    await _firestore.collection("users").doc(currentUser!.uid).delete();

    // Delete from Firebase Auth
    await currentUser!.delete();
    await _firebaseAuth.signOut();
  }

  // Reset password with current password
  Future<void> resetPasswodFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}
