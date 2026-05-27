import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  String? _userId;
  static const _storageKey = 'zgm_orders_v1';

  OrderProvider() {
    _loadOrders();
  }

  List<Order> get orders => List.unmodifiable(_orders);

  void setUserId(String? userId) {
    if (_userId == userId) return;
    _userId = userId;
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    _orders.insert(0, order);
    notifyListeners();
    _saveOrders();

    Future.delayed(const Duration(seconds: 8), () {
      updateOrderStatus(order.id, 'on_way');
    });
    Future.delayed(const Duration(seconds: 18), () {
      updateOrderStatus(order.id, 'delivered');
    });
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return;
    _orders[index].status = status;
    notifyListeners();
    _saveOrders();
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Order> getActiveOrders() => _orders.where((o) => o.status != 'delivered').toList();

  List<Order> getCompletedOrders() => _orders.where((o) => o.status == 'delivered').toList();

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {}
  }

  Future<void> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null) return;
      final list = jsonDecode(jsonString) as List<dynamic>;
      _orders.clear();
      for (var item in list) {
        _orders.add(Order.fromJson(Map<String, dynamic>.from(item)));
      }
      notifyListeners();
    } catch (_) {}
  }
}
