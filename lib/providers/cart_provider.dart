import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  static const _storageKey = 'zgm_cart_items_v1';

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return;
    try {
      final data = jsonDecode(jsonString) as List<dynamic>;
      _cartItems.clear();
      for (var item in data) {
        _cartItems.add(CartItem.fromJson(Map<String, dynamic>.from(item)));
      }
      notifyListeners();
    } catch (_) {}
  }

  List<CartItem> get cartItems => _cartItems;

  int get cartCount => _cartItems.length;

  double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + item.getTotalPrice());
  }

  void addToCart(Product product) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.productId == product.id,
      orElse: () => CartItem(
        productId: '',
        name: '',
        price: '',
        emoji: '',
        quantity: 0,
      ),
    );

    if (existingItem.productId.isNotEmpty) {
      existingItem.quantity++;
    } else {
      _cartItems.add(
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          emoji: product.emoji,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
    _saveCart();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
    _saveCart();
  }

  void updateQuantity(String productId, int quantity) {
    final item = _cartItems.firstWhere((item) => item.productId == productId);
    if (quantity <= 0) {
      removeFromCart(productId);
    } else {
      item.quantity = quantity;
      notifyListeners();
      _saveCart();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
    _saveCart();
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_cartItems.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {}
  }
}
