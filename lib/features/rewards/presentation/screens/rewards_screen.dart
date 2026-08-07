import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/rewards/presentation/widgets/history_tab_widget.dart';
import 'package:cash_for_trash/features/rewards/presentation/widgets/leaderboard_tab_widget.dart';
import 'package:cash_for_trash/features/rewards/presentation/widgets/rewards_header_widget.dart';
import 'package:cash_for_trash/features/rewards/presentation/widgets/rewards_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          const RewardsHeaderWidget(),
          Container(
            color: colorScheme.primary,
            child: Container(
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    labelColor: colorScheme.onPrimary,
                    unselectedLabelColor: colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                    labelStyle: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: [
                      Tab(text: context.tr('rewards')),
                      Tab(text: context.tr('explore')),
                      Tab(text: context.tr('history_pickups')),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const RewardsTabWidget(),
                const LeaderboardTabWidget(),
                const HistoryTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
