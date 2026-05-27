import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  ProductProvider() {
    _seedProducts();
  }

  void _seedProducts() {
    final seed = [
      Product(
        id: '1',
        name: 'Fresh Apple',
        price: '₹120',
        originalPrice: '₹150',
        discount: '20%',
        category: 'Fruits',
        emoji: '🍎',
        description: 'Fresh red apples from local farms',
        rating: 5,
      ),
      Product(
        id: '2',
        name: 'Banana',
        price: '₹60',
        originalPrice: '₹80',
        discount: '25%',
        category: 'Fruits',
        emoji: '🍌',
        description: 'Golden ripe bananas',
        rating: 4,
      ),
      Product(
        id: '3',
        name: 'Tomato',
        price: '₹40',
        originalPrice: '₹50',
        discount: '20%',
        category: 'Vegetables',
        emoji: '🍅',
        description: 'Fresh vine-ripened tomatoes',
        rating: 4,
      ),
      Product(
        id: '4',
        name: 'Milk',
        price: '₹30',
        originalPrice: '₹35',
        discount: '14%',
        category: 'Dairy',
        emoji: '🥛',
        description: 'Pure fresh milk',
        rating: 5,
      ),
      Product(
        id: '5',
        name: 'Bread',
        price: '₹45',
        originalPrice: '₹50',
        discount: '10%',
        category: 'Bakery',
        emoji: '🍞',
        description: 'Fresh baked bread',
        rating: 4,
      ),
      Product(
        id: '6',
        name: 'Potato',
        price: '₹25',
        originalPrice: '₹30',
        discount: '17%',
        category: 'Vegetables',
        emoji: '🥔',
        description: 'Fresh potatoes',
        rating: 4,
      ),
      Product(
        id: '7',
        name: 'Carrot',
        price: '₹35',
        originalPrice: '₹45',
        discount: '22%',
        category: 'Vegetables',
        emoji: '🥕',
        description: 'Organic carrots',
        rating: 5,
      ),
      Product(
        id: '8',
        name: 'Orange',
        price: '₹80',
        originalPrice: '₹100',
        discount: '20%',
        category: 'Fruits',
        emoji: '🍊',
        description: 'Sweet oranges',
        rating: 4,
      ),
      Product(
        id: '9',
        name: 'Onion',
        price: '₹20',
        originalPrice: '₹25',
        discount: '20%',
        category: 'Vegetables',
        emoji: '🧅',
        description: 'Fresh onions',
        rating: 4,
      ),
      Product(
        id: '10',
        name: 'Yogurt',
        price: '₹50',
        originalPrice: '₹60',
        discount: '17%',
        category: 'Dairy',
        emoji: '🥄',
        description: 'Creamy yogurt',
        rating: 5,
      ),
      Product(
        id: '11',
        name: 'Butter',
        price: '₹90',
        originalPrice: '₹110',
        discount: '18%',
        category: 'Dairy',
        emoji: '🧈',
        description: 'Pure butter',
        rating: 5,
      ),
      Product(
        id: '12',
        name: 'Tea',
        price: '₹150',
        originalPrice: '₹180',
        discount: '17%',
        category: 'Drinks',
        emoji: '🍵',
        description: 'Premium tea leaves',
        rating: 4,
      ),
    ];

    _products.addAll(seed);
    notifyListeners();
  }

  List<Product> get products => List.unmodifiable(_products);

  List<String> get categories => _products.map((p) => p.category).toSet().toList();

  List<Product> getProductsByCategory(String category) => _products.where((p) => p.category == category).toList();

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void toggleWishlist(String productId) {
    final product = getProductById(productId);
    if (product != null) {
      product.isWishlisted = !product.isWishlisted;
      notifyListeners();
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return products;
    return _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()) || p.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
