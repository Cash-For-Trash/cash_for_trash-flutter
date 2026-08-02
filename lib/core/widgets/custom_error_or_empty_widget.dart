import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorOrEmptyWidget extends StatelessWidget {
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? title;
  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const CustomErrorOrEmptyWidget({
    super.key,
    required this.isError,
    this.errorMessage,
    this.onRetry,
    this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final displayIcon = icon ??
        (isError
            ? Icons.error_outline_rounded
            : Icons.inbox_outlined);

    final displayTitle = title ??
        (isError
            ? context.tr('error_something_went_wrong')
            : context.tr('empty_no_items'));

    final displayMessage = message ??
        (isError
            ? (errorMessage ?? context.tr('something_went_wrong'))
            : context.tr('empty_no_items_desc'));

    final iconColor = isError
        ? context.colorScheme.error
        : context.colorScheme.primary;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                size: 56.r,
                color: iconColor,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              displayTitle,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            if (isError && onRetry != null) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: 160.w,
                child: CustomPrimaryButton(
                  text: context.tr('retry'),
                  onTap: onRetry!,
                ),
              ),
            ] else if (!isError && onAction != null && actionLabel != null) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: 180.w,
                child: CustomPrimaryButton(
                  text: actionLabel!,
                  onTap: onAction!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
