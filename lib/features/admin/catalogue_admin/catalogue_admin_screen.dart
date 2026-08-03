import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';


import '../areas_admin/presentation/screens/areas_admin_screen.dart';
import '../availabilities_admin/presentation/screens/availabilities_admin_screen.dart';
import '../garbage_types_admin/presentation/screens/garbage_types_admin_screen.dart';
import '../redemptions_admin/presentation/screens/redemptions_admin_screen.dart';
import '../rewards_admin/presentation/screens/rewards_admin_screen.dart';

class CatalogueAdminScreen extends StatefulWidget {
  const CatalogueAdminScreen({super.key});

  @override
  State<CatalogueAdminScreen> createState() => _CatalogueAdminScreenState();
}

class _CatalogueAdminScreenState extends State<CatalogueAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_catalogue'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: context.colorScheme.primary,
          unselectedLabelColor: context.colorScheme.onSurfaceVariant,
          indicatorColor: context.colorScheme.primary,
          tabs: [
            Tab(text: context.tr('admin_areas')),
            Tab(text: context.tr('admin_garbage_types')),
            Tab(text: context.tr('admin_rewards')),
            Tab(text: context.tr('admin_redemptions')),
            Tab(text: context.tr('admin_availabilities')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AreasAdminScreen(),
          GarbageTypesAdminScreen(),
          RewardsAdminScreen(),
          RedemptionsAdminScreen(),
          AvailabilitiesAdminScreen(),
        ],
      ),
    );
  }
}
