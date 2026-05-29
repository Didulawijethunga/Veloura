import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String _userName = '';
  String _userEmail = '';
  bool _authReady = false;

  bool get isLoggedIn => _user != null;
  bool get authReady => _authReady;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get userId => _user?.uid;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    _user = user;
    if (user != null) {
      try {
        final doc = await _db.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          _userName = doc.data()!['name'] as String? ??
              user.email?.split('@').first ?? '';
          _userEmail = doc.data()!['email'] as String? ?? user.email ?? '';
        } else {
          _userName = user.email?.split('@').first ?? '';
          _userEmail = user.email ?? '';
        }
      } catch (_) {
        _userName = user.email?.split('@').first ?? '';
        _userEmail = user.email ?? '';
      }
    } else {
      _userName = '';
      _userEmail = '';
    }
    _authReady = true;
    notifyListeners();
  }

  /// Returns null on success, or an error message string.
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    } catch (e) {
      return 'Login failed: $e';
    }
  }

  /// Returns null on success, or an error message string.
  Future<String?> register(
      String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        throw 'Firestore timeout. Have you created the Firestore Database in your Firebase Console?';
      });
      _userName = name.trim();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    } catch (e) {
      return 'Registration failed: $e';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Returns null on success, or an error message string.
  Future<String?> updateProfile(String name, String email) async {
    if (_user == null) return 'Not logged in.';
    try {
      await _db.collection('users').doc(_user!.uid).update({
        'name': name.trim(),
        'email': email.trim(),
      });
      _userName = name.trim();
      _userEmail = email.trim();
      notifyListeners();
      return null;
    } catch (e) {
      return 'Failed to update profile.';
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication error ($code). Please try again.';
    }
  }
}
