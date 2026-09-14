import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/collection_request_worker_model.dart';

class RequestCardCollectionWorkerWidget extends StatelessWidget {
  final CollectionRequestWorkerModel request;
  final VoidCallback onTap;
  final VoidCallback? onStatusAction;
  final String? actionButtonText;

  const RequestCardCollectionWorkerWidget({
    super.key,
    required this.request,
    required this.onTap,
    this.onStatusAction,
    this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.customerName.isNotEmpty ? request.customerName : context.tr('customer'),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                statusBadge(context, request.status),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                if (request.address.isNotEmpty) ...[
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: context.colorScheme.primary,
                ),
                SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      request.address,
                      style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ]
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16.sp,
                  color: context.colorScheme.secondary,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    request.formattedScheduledSlot.isNotEmpty
                        ? request.formattedScheduledSlot
                        : context.tr('time_not_specified'),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (actionButtonText != null && onStatusAction != null) ...[
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStatusAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    actionButtonText!,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget statusBadge(BuildContext context, String status) {
    Color bg = context.colorScheme.primaryContainer;
    Color fg = context.colorScheme.primary;
    String label = context.tr('status_assigned');

    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        bg = context.colorScheme.tertiaryContainer;
        fg = context.colorScheme.tertiary;
        label = context.tr('status_accepted');
        break;
      case 'ON_THE_WAY':
        bg = context.colorScheme.secondaryContainer;
        fg = context.colorScheme.secondary;
        label = context.tr('status_on_the_way');
        break;
      case 'COLLECTED':
        bg = context.colorScheme.primaryContainer;
        fg = context.colorScheme.primary;
        label = context.tr('status_collected');
        break;
      case 'CANCELLED':
        bg = context.colorScheme.errorContainer;
        fg = context.colorScheme.error;
        label = context.tr('status_cancelled');
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
