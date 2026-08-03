import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/features/rewards/data/model/reward_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardCardWidget extends StatelessWidget {
  final RewardModel reward;

  const RewardCardWidget({super.key, required this.reward});

  Color _iconColorForReward(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('tree') || lower.contains('شجر')) {
      return Colors.green;
    } else if (lower.contains('phone') || lower.contains('شحن')) {
      return Colors.blue;
    } else if (lower.contains('gift') || lower.contains('هدية') || lower.contains('تبرع')) {
      return Colors.purple;
    } else if (lower.contains('discount') || lower.contains('خصم') || lower.contains('هايبر')) {
      return Colors.deepOrange;
    }
    return Colors.grey;
  }

  Color _iconBgColorForReward(String name) {
    return _iconColorForReward(name).withValues(alpha: 0.15);
  }

  IconData _iconForReward(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('tree') || lower.contains('شجر')) {
      return Icons.park_rounded;
    } else if (lower.contains('bottle') || lower.contains('زجاج')) {
      return Icons.water_drop_rounded;
    } else if (lower.contains('gift') || lower.contains('هدية') || lower.contains('كارد') || lower.contains('تبرع')) {
      return Icons.card_giftcard_rounded;
    } else if (lower.contains('phone') || lower.contains('شحن')) {
      return Icons.phone_android_rounded;
    } else if (lower.contains('discount') || lower.contains('خصم') || lower.contains('هايبر')) {
      return Icons.shopping_cart_outlined;
    }
    return Icons.redeem_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final primary = colorScheme.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: _iconBgColorForReward(reward.name),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              _iconForReward(reward.name),
              color: _iconColorForReward(reward.name),
              size: 24.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: primary,
                      size: 14.r,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '${reward.requiredPoints} نقطة',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(70.w, 36.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'استبدل',
              style: context.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
