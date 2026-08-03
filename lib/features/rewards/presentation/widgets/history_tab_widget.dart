import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryTabWidget extends StatelessWidget {
  const HistoryTabWidget({super.key});

  static const List<Map<String, dynamic>> _transactions = [
    {
      'title': 'جمع بلاستيك مختلط',
      'subtitle': 'اليوم',
      'points': '+30',
      'isPositive': true,
      'icon': Icons.recycling_rounded,
    },
    {
      'title': 'جمع ورق وكرتون',
      'subtitle': 'أمس',
      'points': '+45',
      'isPositive': true,
      'icon': Icons.recycling_rounded,
    },
    {
      'title': 'شحن رصيد 20 جنيه',
      'subtitle': 'الثلاثاء',
      'points': '-150',
      'isPositive': false,
      'icon': Icons.shopping_cart_rounded,
    },
    {
      'title': 'جمع معادن',
      'subtitle': 'الثلاثاء',
      'points': '+60',
      'isPositive': true,
      'icon': Icons.recycling_rounded,
    },
    {
      'title': 'استبدال مكافأة',
      'subtitle': 'الأحد',
      'points': '-100',
      'isPositive': false,
      'icon': Icons.shopping_cart_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final success = context.extraColors.success ?? colorScheme.primary;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: _transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final tx = entry.value;
          final isPositive = tx['isPositive'] as bool;
          final pointsColor = isPositive ? success : colorScheme.error;

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colorScheme.outline, width: 1.2),
            ),
            child: Row(
              children: [
                Text(
                  tx['points'] as String,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: pointsColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tx['title'] as String,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        tx['subtitle'] as String,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: isPositive
                        ? colorScheme.primaryContainer
                        : colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    tx['icon'] as IconData,
                    color: isPositive ? colorScheme.primary : colorScheme.error,
                    size: 20.r,
                  ),
                ),
              ],
            ),
          ).animate(delay: (index * 70).ms).fade(duration: 350.ms).slideY(
                begin: 0.06,
                curve: Curves.easeOut,
              );
        }).toList(),
      ),
    );
  }
}
