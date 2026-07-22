import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDialogSplashWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  const ErrorDialogSplashWidget({
    super.key,
    required this.errorMessage,
    required this.onRefresh,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: context.colorScheme.surface,
      title: Text(
        context.tr('error'),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: context.colorScheme.error,
        ),
      ),
      content: Text(
        errorMessage,
        style: TextStyle(
          fontSize: 14.sp,
          color: context.colorScheme.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onLogout,
          child: Text(
            context.tr('logout'),
            style: TextStyle(
              fontSize: 14.sp,
              color: context.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onRefresh,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            context.tr('refresh'),
            style: TextStyle(
              fontSize: 14.sp,
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
