import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/home_admin_bloc.dart';
import '../widgets/quick_action_card_home_admin_widget.dart';
import '../widgets/stats_card_home_admin_widget.dart';

class HomeAdminScreen extends StatelessWidget {
  final Function(int index)? onNavigateTab;

  const HomeAdminScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_dashboard'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<HomeAdminBloc, HomeAdminState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('good_morning'),
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.2,
                  children: [
                    StatsCardHomeAdminWidget(
                      title: context.tr('admin_workers'),
                      value: '',
                      icon: Icons.engineering_rounded,
                      color: Colors.blue,
                      onTap: () => onNavigateTab?.call(1),
                    ),
                    StatsCardHomeAdminWidget(
                      title: context.tr('admin_customers'),
                      value: '',
                      icon: Icons.people_rounded,
                      color: Colors.teal,
                      onTap: () => onNavigateTab?.call(2),
                    ),
                    StatsCardHomeAdminWidget(
                      title: context.tr('admin_areas'),
                      value: '',
                      icon: Icons.map_rounded,
                      color: Colors.green,
                      onTap: () => onNavigateTab?.call(3),
                    ),
                    StatsCardHomeAdminWidget(
                      title: context.tr('admin_redemptions'),
                      value: '',
                      icon: Icons.card_giftcard_rounded,
                      color: Colors.purple,
                      onTap: () => onNavigateTab?.call(3),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  context.tr('quick_actions'),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                QuickActionCardHomeAdminWidget(
                  title: context.tr('admin_workers'),
                  subtitle: context.tr('admin_pending_workers'),
                  icon: Icons.engineering_outlined,
                  onTap: () => onNavigateTab?.call(1),
                ),
                SizedBox(height: 8.h),
                QuickActionCardHomeAdminWidget(
                  title: context.tr('admin_customers'),
                  subtitle: context.tr('empty_no_items_desc'),
                  icon: Icons.people_outline_rounded,
                  onTap: () => onNavigateTab?.call(2),
                ),
                SizedBox(height: 8.h),
                QuickActionCardHomeAdminWidget(
                  title: context.tr('admin_catalogue'),
                  subtitle: context.tr('admin_areas'),
                  icon: Icons.grid_view_outlined,
                  onTap: () => onNavigateTab?.call(3),
                ),
                SizedBox(height: 8.h),
                QuickActionCardHomeAdminWidget(
                  title: context.tr('admin_pricing'),
                  subtitle: context.tr('admin_worker_percentage'),
                  icon: Icons.payments_outlined,
                  onTap: () => onNavigateTab?.call(4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
