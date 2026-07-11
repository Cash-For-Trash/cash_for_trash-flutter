import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyImpactSection extends StatelessWidget {
  final HomeDataModel data;

  const MonthlyImpactSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: context.colorScheme.onPrimary,
              size: 20.sp,
            ),
          ),
          Spacer(),
          _buildImpactCol(
            context,
            value: "${data.monthlyImpactTrees}",
            label: context.tr('trees'),
          ),
          SizedBox(width: 24.w),
          _buildImpactCol(
            context,
            value: "${data.monthlyImpactRecycledKg}",
            label: context.tr('recycled'),
          ),
          SizedBox(width: 24.w),
          _buildImpactCol(
            context,
            value: "${data.monthlyImpactCollectedKg}",
            label: context.tr('collected'),
          ),
          Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.tr('monthly_impact'),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCol(
    BuildContext context, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
