import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButtonProfileWidget extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButtonProfileWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          border: Border.all(
            color: context.colorScheme.error.withValues(alpha: 0.3),
            width: 1.6.w,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: context.colorScheme.error,
              size: 18.w,
            ),
            SizedBox(width: 8.w),
            Text(
              context.tr('logout'),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
