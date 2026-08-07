import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:cash_for_trash/features/rewards/presentation/widgets/reward_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsTabWidget extends StatelessWidget {
  const RewardsTabWidget({super.key});

  void _showRedeemResultDialog(
    BuildContext context, {
    required bool isSuccess,
    required String message,
  }) {
    final colorScheme = context.colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
              color: isSuccess
                  ? (context.extraColors.success ?? colorScheme.primary)
                  : colorScheme.error,
              size: 56.r,
            ),
            SizedBox(height: 16.h),
            Text(
              isSuccess
                  ? context.tr('redeem_success_title')
                  : context.tr('redeem_failed_title'),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context
                      .read<RewardsBloc>()
                      .add(const ClearRedeemStatusEvent());
                  if (isSuccess) {
                    context.read<RewardsBloc>().add(const GetRewardsEvent());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess
                      ? (context.extraColors.success ?? colorScheme.primary)
                      : colorScheme.error,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(context.tr('ok')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RewardsBloc, RewardsState>(
      listenWhen: (prev, curr) =>
          prev.redeemSuccessMessage != curr.redeemSuccessMessage ||
          prev.redeemErrorMessage != curr.redeemErrorMessage,
      listener: (context, state) {
        if (state.redeemSuccessMessage != null) {
          _showRedeemResultDialog(
            context,
            isSuccess: true,
            message: state.redeemSuccessMessage!,
          );
        } else if (state.redeemErrorMessage != null) {
          _showRedeemResultDialog(
            context,
            isSuccess: false,
            message: state.redeemErrorMessage!,
          );
        }
      },
      child: BlocBuilder<RewardsBloc, RewardsState>(
        builder: (context, state) {
          if (state.isRewardsLoading || state.isRedeeming) {
            return Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            );
          }

          if (state.rewardsErrorMessage != null && state.rewards.isEmpty) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.rewardsErrorMessage,
              onRetry: () =>
                  context.read<RewardsBloc>().add(const GetRewardsEvent()),
            );
          }

          if (state.rewards.isEmpty) {
            return CustomErrorOrEmptyWidget(
              isError: false,
              title: context.tr('admin_rewards'),
              message: context.tr('no_rewards_available'),
              icon: Icons.card_giftcard_rounded,
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.tr('redeem_rewards_title'),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                ...state.rewards.asMap().entries.map((entry) {
                  return RewardCardWidget(reward: entry.value)
                      .animate(delay: (entry.key * 80).ms)
                      .fade(duration: 350.ms)
                      .slideY(begin: 0.08, curve: Curves.easeOut);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
