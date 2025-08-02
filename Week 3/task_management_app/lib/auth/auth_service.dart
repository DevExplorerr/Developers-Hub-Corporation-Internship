import 'package:firebase_auth/firebase_auth.dart';
import '../global/toast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email, password, and username
  Future<User?> signUp(String username, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user's display name
      await credential.user!.updateDisplayName(username);
      await credential.user!.reload();

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: "The email address is already in use.");
      } else {
        showToast(message: "Error: ${e.code}");
      }
    } catch (e) {
      showToast(message: "Unexpected error occurred.");
    }
    return null;
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.reload();

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: "Invalid email or password.");
      } else {
        showToast(message: "Error: ${e.code}");
      }
    } catch (e) {
      showToast(message: "Unexpected error occurred.");
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
