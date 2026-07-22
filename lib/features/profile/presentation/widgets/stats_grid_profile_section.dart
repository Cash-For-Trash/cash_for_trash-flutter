import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsGridProfileSection extends StatelessWidget {
  const StatsGridProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            value: '350',
            label: context.tr('points'),
            valueColor: Colors.orange,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildStatCard(
            context,
            value: '47',
            label: context.tr('kg'),
            valueColor: Colors.blue,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildStatCard(
            context,
            value: '12',
            label: context.tr('orders'),
            valueColor: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.8.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.1),
          width: 0.8.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 1.5.h,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
