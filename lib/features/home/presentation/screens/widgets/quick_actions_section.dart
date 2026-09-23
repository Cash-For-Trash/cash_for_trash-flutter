import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.requestCollectionScreen),
        borderRadius: BorderRadius.circular(24.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 16.w, 18.h),
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58.r,
                height: 58.r,
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  Icons.recycling_rounded,
                  color: context.colorScheme.onPrimary,
                  size: 34.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.onPrimary.withValues(
                          alpha: 0.16,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        context.tr('start_now'),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Text(
                      context.tr('request_collection'),
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      context.tr('request_collection_cta_hint'),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onPrimary.withValues(
                          alpha: 0.82,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: context.colorScheme.onPrimary,
                size: 27.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
