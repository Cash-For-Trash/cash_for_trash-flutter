import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF388E3C);
  static const Color secondary = Color(0xFF66BB6A);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color secondaryContainer = Color(0xFFF1F8E9);

  static const Color surface = Color(0xFFF8FAF8);
  static const Color surfaceBright = Color(0xFFFCFDFC);
  static const Color surfaceDim = Color(0xFFF1F4F1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF4F7F4);
  static const Color surfaceContainer = Color(0xFFEEF2EE);
  static const Color surfaceContainerHigh = Color(0xFFE8ECE8);
  static const Color surfaceContainerHighest = Color(0xFFE2E7E2);

  static const Color textPrimary = Color(0xFF1E2939);
  static const Color textSecondary = Color(0xFF6A7282);
  static const Color textDisabled = Color(0xFF99A1AF);

  static const Color outline = Color(0xFFF3F4F6);
  static const Color outlineVariant = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFF0FFF4);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFFFBEB);
  
  static const Color info = Color(0xFF155DFC);
  static const Color infoContainer = Color(0xFFEFF6FF);

  static const Color darkSurface = Color(0xFF101511);
  static const Color darkSurfaceContainer = Color(0xFF182019);
  static const Color darkSurfaceContainerHigh = Color(0xFF202A21);
  static const Color darkTextPrimary = Color(0xFFF1F5F1);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}