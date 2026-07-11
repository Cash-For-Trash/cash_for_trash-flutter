import 'package:flutter/material.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient header = LinearGradient(
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF388E3C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.06, 0.58, 0.94],
  );

  static const LinearGradient progress = LinearGradient(
    colors: [
      Color(0xFF2E7D32),
      Color(0xFF66BB6A),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient ecoCard = LinearGradient(
    colors: [
      Color(0xFFE8F5E9),
      Color(0xFFF1F8E9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}