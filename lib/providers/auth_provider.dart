import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AppUser? _user;
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> login(String emailInput, String passwordInput) async {
    _isLoading = true;
    notifyListeners();

    try {
      final email = emailInput.trim().toLowerCase();
      final password = passwordInput.trim();

      final snapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        _user = AppUser.fromFirestore(doc.id, doc.data());
      } else {
        throw 'Email atau password salah!';
      }
    } catch (e) {
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}
