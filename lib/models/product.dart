import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final String originalPrice;
  final String discount;
  final String category;
  final String emoji;
  final String description;
  final int rating;
  int quantity;
  bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.category,
    required this.emoji,
    required this.description,
    required this.rating,
    this.quantity = 0,
    this.isWishlisted = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      originalPrice: json['originalPrice'] ?? '',
      discount: json['discount'] ?? '',
      category: json['category'] ?? '',
      emoji: json['emoji'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating'] ?? 4,
      quantity: json['quantity'] ?? 0,
      isWishlisted: json['isWishlisted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'category': category,
      'emoji': emoji,
      'description': description,
      'rating': rating,
      'quantity': quantity,
      'isWishlisted': isWishlisted,
    };
  }

  double getPriceAsDouble() {
    return double.tryParse(price.replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
  }
}
