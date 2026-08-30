import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentOrderSection extends StatelessWidget {
  final List<CurrentOrderModel?> orders;

  const CurrentOrderSection({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final warningColor =
        context.extraColors.warning ?? context.colorScheme.secondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.colorScheme.outline, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),

              Text(
                context.tr('current_order'),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              if (order == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: warningColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          order.status,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: warningColor,
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
                              order.title,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (order.timeLeft.isNotEmpty)
                              Text(
                                '• ${order.timeLeft}',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
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
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
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

                  SizedBox(height: 16.h),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: order.progress,
                      minHeight: 6.h,
                      backgroundColor: context.colorScheme.outline,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorScheme.primary,
                      ),
                    ),
                  ),

                  if (index != orders.length - 1) SizedBox(height: 16.h),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
