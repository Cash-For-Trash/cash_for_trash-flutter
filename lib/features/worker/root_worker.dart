import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/widgets/app_exit_pop_scope.dart';
import 'package:cash_for_trash/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_for_trash/features/worker/availability_worker/presentation/screens/availability_worker_screen.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/screens/collection_requests_worker_screen.dart';
import 'package:cash_for_trash/features/worker/custom_worker_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RootWorker extends StatefulWidget {
  final bool isSupervisorView;
  final String? workerId;
  final String? workerName;

  const RootWorker({
    super.key,
    this.isSupervisorView = false,
    this.workerId,
    this.workerName,
  });

  @override
  State<RootWorker> createState() => RootWorkerState();
}

class RootWorkerState extends State<RootWorker> {
  PageController controller = PageController();
  int currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });

    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _logout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.tr('logout_confirm_title')),
        content: Text(context.tr('logout_confirm_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.tr('no')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              context.tr('yes'),
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await CacheHelper.removeAllSecretData();
      await CacheHelper().clearUserData();
      if (mounted) {
        context.go(AppRoutes.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const CollectionRequestsWorkerScreen(),
      const AvailabilityWorkerScreen(),
      const ProfileScreen(),
    ];

    return AppExitPopScope(
      child: Scaffold(
        appBar: widget.isSupervisorView
            ? AppBar(
                title: Text(
                  widget.workerName != null && widget.workerName!.isNotEmpty
                      ? widget.workerName!
                      : context.tr('supervisor_dashboard'),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () async {
                    await CacheHelper.saveData(key: 'selected_worker_id', value: null);
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: _logout,
                    icon: Icon(
                      Icons.logout_rounded,
                      color: context.colorScheme.error,
                      size: 22.r,
                    ),
                    tooltip: context.tr('logout'),
                  ),
                ],
              )
            : null,
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: CustomWorkerNavBar(
          currentIndex: currentIndex,
          onTap: changePage,
        ),
      ),
    );
  }
}
