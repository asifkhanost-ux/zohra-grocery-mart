import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFBDBDBD);
  static const Color darkGrey = Color(0xFF424242);
  static const Color black = Color(0xFF000000);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFBC02D);
  static const Color info = Color(0xFF1976D2);
  
  // Gradients
  static const LinearGradient greenGradient = LinearGradient(
    colors: [primaryGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
