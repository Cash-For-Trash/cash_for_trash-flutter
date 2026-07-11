import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextTheme {
  const AppTextTheme._();

  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 57.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 32.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      );

  static TextTheme get darkTextTheme => lightTextTheme.copyWith(
        displayLarge: lightTextTheme.displayLarge?.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge: lightTextTheme.headlineLarge?.copyWith(color: AppColors.darkTextPrimary),
        headlineMedium: lightTextTheme.headlineMedium?.copyWith(color: AppColors.darkTextPrimary),
        titleLarge: lightTextTheme.titleLarge?.copyWith(color: AppColors.darkTextPrimary),
        titleMedium: lightTextTheme.titleMedium?.copyWith(color: AppColors.darkTextPrimary),
        titleSmall: lightTextTheme.titleSmall?.copyWith(color: AppColors.darkTextPrimary),
        bodyLarge: lightTextTheme.bodyLarge?.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium: lightTextTheme.bodyMedium?.copyWith(color: AppColors.darkTextSecondary),
        bodySmall: lightTextTheme.bodySmall?.copyWith(color: AppColors.darkTextSecondary),
      );
}