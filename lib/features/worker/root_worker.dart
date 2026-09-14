import 'package:cash_for_trash/core/widgets/app_exit_pop_scope.dart';
import 'package:cash_for_trash/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_for_trash/features/worker/availability_worker/presentation/screens/availability_worker_screen.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/screens/collection_requests_worker_screen.dart';
import 'package:cash_for_trash/features/worker/custom_worker_nav_bar.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/presentation/screens/earnings_worker_screen.dart';
import 'package:cash_for_trash/features/worker/home_worker/presentation/screens/home_worker_screen.dart';
import 'package:flutter/material.dart';

class RootWorker extends StatefulWidget {
  const RootWorker({super.key});

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

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      // HomeWorkerScreen(onNavigateToPickups: () => changePage(1)),
      const CollectionRequestsWorkerScreen(),
      const AvailabilityWorkerScreen(),
      const EarningsWorkerScreen(),
      const ProfileScreen(),
    ];

    return AppExitPopScope(
      child: Scaffold(
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
