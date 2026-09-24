import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentOrdersSection extends StatefulWidget {
  final List<CustomerCollectionRequestModel?> collectionRequests;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onShowMore;

  const RecentOrdersSection({
    super.key,
    required this.collectionRequests,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onShowMore,
  });

  @override
  State<RecentOrdersSection> createState() => _RecentOrdersSectionState();
}

class _RecentOrdersSectionState extends State<RecentOrdersSection> {
  int _visibleCount = 2;

  @override
  Widget build(BuildContext context) {
    final successColor =
        context.extraColors.success ?? context.colorScheme.primary;
    final warningColor =
        context.extraColors.warning ?? context.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('recent_collection_requests'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.collectionRequests.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Text(
                context.tr('empty_no_items_desc'),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.collectionRequests.length < _visibleCount
                ? widget.collectionRequests.length
                : _visibleCount,
            itemBuilder: (context, index) {
              final order = widget.collectionRequests[index];
              final isCompleted =
                  order?.status.toUpperCase() == "COLLECTED" ||
                  order?.status == "مكتمل";
              final itemColor = isCompleted ? successColor : warningColor;

              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
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

                  // if (index != collectionRequests.length - 1)
                  SizedBox(height: 16.h),
                ],
              );
            },
          ),

        if (widget.hasMore ||
            _visibleCount < widget.collectionRequests.length) ...[
          SizedBox(height: 16.h),
          Center(
            child: widget.isLoadingMore
                ? SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.r,
                      color: context.colorScheme.primary,
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: () {
                      if (_visibleCount < widget.collectionRequests.length) {
                        setState(() => _visibleCount += 3);
                      } else {
                        widget.onShowMore?.call();
                      }
                    },
                    icon: const Icon(Icons.expand_more_rounded),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: context.colorScheme.primary,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      minimumSize: Size(double.infinity, 48.h),
                    ),
                    label: Text(
                      context.tr('show_more'),
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
          ),
        ],
      ],
    );
  }
}
