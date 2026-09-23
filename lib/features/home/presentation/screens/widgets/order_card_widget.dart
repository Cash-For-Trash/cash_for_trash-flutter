import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCardWidget extends StatelessWidget {
  final CustomerCollectionRequestModel? order;
  final int index;
  final bool showProgress;
  final double progressValue;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.index,
    this.showProgress = false,
    this.progressValue = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return const SizedBox.shrink();
    }

    final successColor =
        context.extraColors.success ?? context.colorScheme.primary;
    final warningColor =
        context.extraColors.warning ?? context.colorScheme.secondary;

    final isCompleted =
        order?.status.toUpperCase() == "COLLECTED" || order?.status == "مكتمل";
    final itemColor = isCompleted ? successColor : warningColor;

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                context.tr(order?.status ?? 'N/A'),
                style: context.textTheme.bodySmall?.copyWith(
                  color: itemColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${context.tr('order')}# ${index + 1}",
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    '• ${order?.scheduledDay} ${order?.scheduledFromTime} - ${order?.scheduledToTime}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                color: context.colorScheme.primary,
                size: 24.sp,
              ),
            ),
          ],
        ),

        if (showProgress) ...[
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6.h,
              backgroundColor: context.colorScheme.outline,
              valueColor: AlwaysStoppedAnimation<Color>(
                context.colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
