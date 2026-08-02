import 'package:cash_for_trash/core/widgets/app_exit_pop_scope.dart';
import 'package:flutter/material.dart';
import 'custom_admin_nav_bar.dart';
import 'catalogue_admin/catalogue_admin_screen.dart';
import 'customers_admin/presentation/screens/customers_admin_screen.dart';
import 'home_admin/presentation/screens/home_admin_screen.dart';
import 'pricing_admin/presentation/screens/pricing_admin_screen.dart';
import 'workers_admin/presentation/screens/workers_admin_screen.dart';

class RootAdmin extends StatefulWidget {
  const RootAdmin({super.key});

  @override
  State<RootAdmin> createState() => RootAdminState();
}

class RootAdminState extends State<RootAdmin> {
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
    final List<Widget> screens = [
      HomeAdminScreen(onNavigateTab: changePage),
      const WorkersAdminScreen(),
      const CustomersAdminScreen(),
      const CatalogueAdminScreen(),
      const PricingAdminScreen(),
    ];

    return AppExitPopScope(
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: CustomAdminNavBar(
          currentIndex: currentIndex,
          onTap: changePage,
        ),
      ),
    );
  }
}
