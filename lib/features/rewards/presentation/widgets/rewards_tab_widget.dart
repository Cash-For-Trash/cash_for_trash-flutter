import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:cash_for_trash/features/rewards/presentation/widgets/reward_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsTabWidget extends StatelessWidget {
  const RewardsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardsBloc, RewardsState>(
      builder: (context, state) {
        if (state is RewardsLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: context.colorScheme.primary,
            ),
          );
        }

        if (state is RewardsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: context.colorScheme.error,
                  size: 48.r,
                ),
                SizedBox(height: 12.h),
                Text(
                  state.message,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () =>
                      context.read<RewardsBloc>().add(const GetRewardsEvent()),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is RewardsLoaded) {
          if (state.rewards.isEmpty) {
            return Center(
              child: Text(
                'لا توجد مكافآت متاحة',
                style: context.textTheme.bodyLarge,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'استبدال المكافآت',
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
        }

        return const SizedBox.shrink();
      },
    );
  }
}
