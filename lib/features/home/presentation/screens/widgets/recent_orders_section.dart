import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentOrdersSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('recent_collection_requests'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (collectionRequests.isEmpty)
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
            itemCount: collectionRequests.length,
            itemBuilder: (context, index) {
              final order = collectionRequests[index];

              return Column(
                children: [
                  OrderCardWidget(order: order, index: index),
                  SizedBox(height: 32.h),
                ],
              );
            },
          ),

        if (hasMore) ...[
          SizedBox(height: 16.h),
          Center(
            child: isLoadingMore
                ? SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.r,
                      color: context.colorScheme.primary,
                    ),
                  )
                : OutlinedButton(
                    onPressed: onShowMore,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: context.colorScheme.primary,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
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
