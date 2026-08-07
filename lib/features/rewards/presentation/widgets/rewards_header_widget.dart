import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsHeaderWidget extends StatefulWidget {
  const RewardsHeaderWidget({super.key});

  @override
  State<RewardsHeaderWidget> createState() => _RewardsHeaderWidgetState();
}

class _RewardsHeaderWidgetState extends State<RewardsHeaderWidget> {
  @override
  void initState() {
    super.initState();
    context.read<RewardsBloc>().add(const GetCustomerPointsEvent());
  }

  _LevelDetails _calculateLevel(int points) {
    if (points < 200) {
      return _LevelDetails(
        levelKey: 'bronze_level',
        subText: '${200 - points} ${context.tr('for_silver')}',
      );
    } else if (points < 500) {
      return _LevelDetails(
        levelKey: 'silver_level',
        subText: '${500 - points} ${context.tr('for_gold')}',
      );
    } else if (points < 1000) {
      return _LevelDetails(
        levelKey: 'gold_level',
        subText: '${1000 - points} ${context.tr('for_platinum')}',
      );
    } else {
      return _LevelDetails(
        levelKey: 'platinum_level',
        subText: context.tr('max_level'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: BlocBuilder<RewardsBloc, RewardsState>(
            buildWhen: (prev, curr) =>
                prev.customerPoints != curr.customerPoints ||
                prev.isCustomerPointsLoading != curr.isCustomerPointsLoading,
            builder: (context, state) {
              final points = state.customerPoints;
              final pointsStr = state.isCustomerPointsLoading
                  ? '...'
                  : points.toString();
              final levelDetails = _calculateLevel(points);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.tr('rewards'),
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 28.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            pointsStr,
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        context.tr('green_points'),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: onPrimary.withValues(alpha: 0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: onPrimary.withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.tr('level'),
                          style: context.textTheme.labelMedium?.copyWith(
                            color: onPrimary.withValues(alpha: 0.8),
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          context.tr(levelDetails.levelKey),
                          style: context.textTheme.titleLarge?.copyWith(
                            color: onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          levelDetails.subText,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: onPrimary.withValues(alpha: 0.8),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LevelDetails {
  final String levelKey;
  final String subText;

  _LevelDetails({required this.levelKey, required this.subText});
}
