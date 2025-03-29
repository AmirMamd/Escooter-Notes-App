import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFB0202);
  static const Color secondary = Color(0xFFBCBCBF);
  static const Color container = Color(0xFFF1F1FA);
  static const Color accent = Color(0xFFFF5722);
  static const Color background = Color(0xFF000000);
  static const Color text = Color(0xFF5A5A5A);
  static const Color checkBox = Color(0xFFF7D52E);
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}