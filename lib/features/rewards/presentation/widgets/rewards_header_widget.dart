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

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
