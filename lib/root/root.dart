import 'package:cash_for_trash/core/di/service_locator.dart';
import 'package:cash_for_trash/core/widgets/app_exit_pop_scope.dart';
import 'package:cash_for_trash/features/home/presentation/screens/home_screen.dart';
import 'package:cash_for_trash/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/request_collection_screen.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:cash_for_trash/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:cash_for_trash/root/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/payment/presentation/bloc/payment_bloc.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => RootState();
}

class RootState extends State<Root> {
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
      const HomeScreen(),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<RequestCollectionBloc>()
              ..add(const GetGarbageTypesEvent())
              ..add(const GetAddressesEvent()),
          ),
          BlocProvider(
            create: (context) => sl<PaymentBloc>(),
          ),
        ],
        child: const RequestCollectionScreen(),
      ),
      BlocProvider(
        create: (context) =>
            sl<RewardsBloc>()..add(const GetRewardsEvent()),
        child: const RewardsScreen(),
      ),
      const ProfileScreen(),
    ];

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

