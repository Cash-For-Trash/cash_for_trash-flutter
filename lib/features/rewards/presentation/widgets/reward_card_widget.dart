import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/features/rewards/data/model/reward_model.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cash_for_trash/core/localization/app_localizations.dart';

class RewardCardWidget extends StatelessWidget {
  final RewardModel reward;

  const RewardCardWidget({super.key, required this.reward});

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

  void _showRedeemDialog(BuildContext context) {
    final colorScheme = context.colorScheme;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Icon(Icons.redeem_rounded, color: colorScheme.primary, size: 24.r),
            SizedBox(width: 10.w),
            Text(
              context.tr('confirm_redemption'),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reward.name,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.star_rounded, color: colorScheme.primary, size: 16.r),
                SizedBox(width: 4.w),
                Text(
                  '${reward.requiredPoints} ${context.tr('points')}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              context.tr('redeem_confirmation_question'),
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              context.tr('cancel'),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<RewardsBloc>().add(RedeemRewardEvent(reward.rewardId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(context.tr('redeem')),
          ),
        ],
      ),
    );
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
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: reward.image != null && reward.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.network(
                      reward.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        _iconForReward(reward.name),
                        color: primary,
                        size: 24.r,
                      ),
                    ),
                  )
                : Icon(
                    _iconForReward(reward.name),
                    color: primary,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                      '${reward.requiredPoints} ${context.tr('points')}',
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
            onPressed: () => _showRedeemDialog(context),
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
              context.tr('redeem'),
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
