import 'package:cash_for_trash/core/widgets/app_exit_pop_scope.dart';
import 'package:cash_for_trash/features/home/presentation/screens/home_screen.dart';
import 'package:cash_for_trash/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_for_trash/root/custom_nav_bar.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => RootState();
}

class RootState extends State<Root> {
  PageController controller = PageController();
  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const Scaffold(body: Center(child: Text('Explore Screen'))),
    const Scaffold(body: Center(child: Text('My Learning Screen'))),
    const ProfileScreen(),
  ];

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
    return AppExitPopScope(
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: currentIndex,
          onTap: changePage,
        ),
      ),
    );
  }
}

