import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/home_worker_model.dart';

class QuickStatsHomeWorkerWidget extends StatelessWidget {
  final HomeWorkerModel data;

  const QuickStatsHomeWorkerWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: statCard(
            context: context,
            title: context.tr('fulfilled_pickups'),
            value: '${data.fulfilledPickupsCount}',
            icon: Icons.assignment_turned_in_rounded,
            accentColor: context.colorScheme.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: statCard(
            context: context,
            title: context.tr('earned_income'),
            value: '${data.totalEarnings.toStringAsFixed(1)} ${context.tr('currency_egp')}',
            icon: Icons.account_balance_wallet_rounded,
            accentColor: context.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget statCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: accentColor, size: 22.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
