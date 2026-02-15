import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  authenticating,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  AuthStatus _status = AuthStatus.uninitialized;

  User? get user => _user;
  AuthStatus get status => _status;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      await _authService.signInWithGoogle();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      // Error handling logic
      print(e); 
    }
  }

  Future<void> signOut() async {
    _authService.signOut();
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }
}
