import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentOrdersSection extends StatelessWidget {
  final List<OrderModel> orders;

  const RecentOrdersSection({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final successColor = context.extraColors.success ?? context.colorScheme.primary;
    final warningColor = context.extraColors.warning ?? context.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14.sp,
                  color: context.colorScheme.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  context.tr('view_all'),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Text(
              context.tr('recent_orders'),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final isCompleted = order.status == "مكتمل";
            final itemColor = isCompleted ? successColor : warningColor;

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: context.colorScheme.outline,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.points,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: itemColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        order.title,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            order.id,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: itemColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              order.status,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: itemColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: itemColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.autorenew_rounded,
                      color: itemColor,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
