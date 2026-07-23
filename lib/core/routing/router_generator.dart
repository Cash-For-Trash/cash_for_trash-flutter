import 'package:cash_for_trash/core/di/service_locator.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/auth/forgot-password/presentation/screens/forgot_password.dart';
import 'package:cash_for_trash/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:cash_for_trash/features/auth/login/presentation/screens/login_screen.dart';
import 'package:cash_for_trash/features/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:cash_for_trash/features/auth/otp/presentation/screens/otp_screen.dart';
import 'package:cash_for_trash/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:cash_for_trash/features/auth/register/presentation/screens/register_screen.dart';
import 'package:cash_for_trash/features/auth/reset_password/presentation/screens/reset_password.dart';
import 'package:cash_for_trash/features/home/presentation/bloc/home_bloc.dart';
import 'package:cash_for_trash/features/onboarding/presentation/screens/onbording_screen.dart';
import 'package:cash_for_trash/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:cash_for_trash/features/splash/presentation/screens/splash_screen.dart';
import 'package:cash_for_trash/root/root.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cash_for_trash/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cash_for_trash/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/request_collection_screen.dart';

// final RouteObserver<ModalRoute<void>> homeRouteObserver =
//     RouteObserver<ModalRoute<void>>();

class RouterGenerator {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    // observers: [homeRouteObserver],
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<SplashBloc>(),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onbordingScreen,
        builder: (context, state) => const OnbordingScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<LoginBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<RegisterBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyOtpScreen,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return BlocProvider(
            create: (context) => sl<OtpBloc>(),
            child: OtpScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPasswordScreen,
        builder: (context, state) => const ResetPassword(),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordScreen,
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: AppRoutes.homeScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<HomeBloc>()..add(GetHomeData()),
            ),
            BlocProvider(create: (context) => sl<ProfileBloc>()),
          ],
          child: const Root(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profileScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ProfileBloc>(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.requestCollectionScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<RequestCollectionBloc>(),
          child: const RequestCollectionScreen(),
        ),
      ),
    ],
  );
}
