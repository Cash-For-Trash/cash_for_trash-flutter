import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickupDetailsWorkerCustomerInfoWidget extends StatelessWidget {
  final CollectionRequestWorkerModel request;

  const PickupDetailsWorkerCustomerInfoWidget({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.customerName.isNotEmpty ? request.customerName : context.tr('customer'),
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: context.colorScheme.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  request.address.isNotEmpty ? request.address : context.tr('default_address_street'),
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.business_rounded, color: context.colorScheme.secondary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                '${context.tr('building')}: ${request.buildingNum} | ${context.tr('floor')}: ${request.floor}',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
          if (request.formattedScheduledSlot.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: context.colorScheme.tertiary, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    request.formattedScheduledSlot,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
