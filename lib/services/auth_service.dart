import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream to listen to authentication changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get the current logged-in user
  static User? get currentUser => _auth.currentUser;

  /// Sign up a new user. Returns an error message if failed, null on success.
  static Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message ?? 'An unknown error occurred.';
    } catch (e) {
      return 'Failed to sign up: $e';
    }
  }

  /// Login an existing user. Returns an error message if failed, null on success.
  static Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-credential') {
        return 'Invalid credentials. Please check your email and password.';
      }
      return e.message ?? 'An unknown error occurred.';
    } catch (e) {
      return 'Failed to login: $e';
    }
  }

  /// Log the current user out
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// Check if there is an active session (synchronous, may be outdated if token expires)
  static Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }
}
