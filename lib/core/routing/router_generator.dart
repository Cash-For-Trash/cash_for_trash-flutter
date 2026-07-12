import 'package:cash_for_trash/core/di/service_locator.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/home/presentation/bloc/home_bloc.dart';
import 'package:cash_for_trash/features/onboarding/presentation/screens/onbording_screen.dart';
import 'package:cash_for_trash/features/splash/presentation/screens/splash_screen.dart';
import 'package:cash_for_trash/root/root.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// final RouteObserver<ModalRoute<void>> homeRouteObserver =
//     RouteObserver<ModalRoute<void>>();

class RouterGenerator {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    // observers: [homeRouteObserver],
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onbordingScreen,
        builder: (context, state) => const OnbordingScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<HomeBloc>()..add(GetHomeData()),
          child: const Root(),
        ),
      ),
    ],
  );
}
