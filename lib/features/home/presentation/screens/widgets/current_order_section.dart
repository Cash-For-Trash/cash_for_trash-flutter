import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentOrderSection extends StatelessWidget {
  final List<CustomerCollectionRequestModel?> currentCollectionRequest;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onShowMore;

  const CurrentOrderSection({
    super.key,
    required this.currentCollectionRequest,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(
                context.tr('current_order'),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(),
            ],
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentCollectionRequest.length,
            itemBuilder: (context, index) {
              final order = currentCollectionRequest[index];

              if (order == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  OrderCardWidget(
                    order: order,
                    index: index,
                    showProgress: true,
                  ),

                  if (index != currentCollectionRequest.length - 1)
                    SizedBox(height: 16.h),
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
      ),
    );
  }
}
