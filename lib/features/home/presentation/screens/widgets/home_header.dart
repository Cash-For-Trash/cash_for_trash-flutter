import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  final HeaderDataModel? data;

  const HomeHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colorScheme.onPrimary;
    final pointsValue = data?.pointsValueInEgp;
    final pointsValueText = pointsValue == null
        ? null
        : pointsValue % 1 == 0
        ? pointsValue.toInt().toString()
        : pointsValue.toStringAsFixed(2);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
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
                        data?.userName ?? context.tr("customer"),
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
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: onPrimary.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.eco_rounded,
                        color: onPrimary,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('green_points'),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: onPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            data?.points ?? '0',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (pointsValueText != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              '$pointsValueText ${context.tr('currency_egp')}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: onPrimary.withValues(alpha: 0.82),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: onPrimary.withValues(alpha: 0.7),
                      size: 22.sp,
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
