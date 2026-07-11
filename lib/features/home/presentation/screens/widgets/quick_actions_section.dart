import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('quick_actions'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionItem(
              context,
              icon: Icons.delete_outline_rounded,
              label: context.tr('request_collection'),
            ),
            _buildActionItem(
              context,
              icon: Icons.near_me_outlined,
              label: context.tr('track_order'),
            ),
            _buildActionItem(
              context,
              icon: Icons.card_giftcard_rounded,
              label: context.tr('rewards'),
            ),
            _buildActionItem(
              context,
              icon: Icons.verified_user_outlined,
              label: context.tr('my_subscription'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: context.colorScheme.primary,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
