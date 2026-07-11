import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  final HomeDataModel data;

  const HomeHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;
    final warning = context.extraColors.warning ?? context.colorScheme.secondary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('good_morning'),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: onPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        data.userName,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: onPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: onPrimary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: onPrimary,
                          size: 26.sp,
                        ),
                        Positioned(
                          right: 2.w,
                          top: 2.h,
                          child: CircleAvatar(
                            radius: 5.r,
                            backgroundColor: context.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: onPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: onPrimary.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60.r,
                          height: 60.r,
                          child: CircularProgressIndicator(
                            value: data.levelProgress,
                            strokeWidth: 5.r,
                            backgroundColor: onPrimary.withValues(alpha: 0.24),
                            color: onPrimary,
                          ),
                        ),
                        Text(
                          "${(data.levelProgress * 100).toInt()}%",
                          style: context.textTheme.titleSmall?.copyWith(
                            color: onPrimary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('to_next_level'),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: onPrimary.withValues(alpha: 0.7),
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            "${data.nextLevelCurrent} / ${data.nextLevelTotal}",
                            style: context.textTheme.titleMedium?.copyWith(
                              color: onPrimary,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.2,
                      height: 48.h,
                      color: onPrimary.withValues(alpha: 0.2),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          context.tr('current_points'),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: onPrimary.withValues(alpha: 0.7),
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "${data.points}",
                          style: context.textTheme.headlineLarge?.copyWith(
                            color: onPrimary,
                            fontSize: 28.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: warning,
                              size: 16.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              context.tr('green_points'),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: onPrimary.withValues(alpha: 0.7),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
