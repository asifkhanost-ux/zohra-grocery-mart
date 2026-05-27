import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  static const _storageKey = 'zgm_user_v1';

  User? _currentUser;
  bool _isLoggedIn = false;

  UserProvider() {
    _loadUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<String?> signIn(String email, String password) async {
    // Simple in-memory check: accept any non-empty email/password
    if (email.isEmpty || password.isEmpty) return 'Invalid credentials';
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Zohra Customer',
      email: email,
      phone: '',
      savedAddresses: [],
      walletBalance: 100.0,
      loyaltyPoints: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
    _saveUser();
    return null;
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (email.isEmpty || password.isEmpty) return 'Invalid input';
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.isNotEmpty ? name : 'Zohra Customer',
      email: email,
      phone: phone,
      savedAddresses: [],
      walletBalance: 100.0,
      loyaltyPoints: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
    _saveUser();
    return null;
  }

  Future<void> logoutUser() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> updateUser(User user) async {
    _currentUser = user;
    notifyListeners();
    _saveUser();
  }

  Future<void> addSavedAddress(String address) async {
    if (_currentUser != null) {
      final updatedAddresses = List<String>.from(_currentUser!.savedAddresses)..add(address);
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        savedAddresses: updatedAddresses,
        walletBalance: _currentUser!.walletBalance,
        loyaltyPoints: _currentUser!.loyaltyPoints,
      );
      notifyListeners();
      _saveUser();
    }
  }

  Future<void> updateWalletBalance(double amount) async {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        savedAddresses: _currentUser!.savedAddresses,
        walletBalance: _currentUser!.walletBalance + amount,
        loyaltyPoints: _currentUser!.loyaltyPoints,
      );
      notifyListeners();
      _saveUser();
    }
  }

  Future<void> _saveUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser == null) {
        await prefs.remove(_storageKey);
        return;
      }
      await prefs.setString(_storageKey, jsonEncode(_currentUser!.toJson()));
    } catch (_) {}
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null) return;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      _currentUser = User.fromJson(data);
      _isLoggedIn = true;
      notifyListeners();
    } catch (_) {}
  }
}
