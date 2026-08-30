import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HeaderAddressWidget extends StatelessWidget {
  const HeaderAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 12.h,
        bottom: 24.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        gradient:
            context.extraColors.headerGradient ??
            LinearGradient(
              colors: [
                context.colorScheme.primary,
                context.colorScheme.primary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.colorScheme.onPrimary,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.tr('addresses'),
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            context.tr('manage_addresses_subtitle'),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onPrimary.withValues(alpha: 0.85),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
