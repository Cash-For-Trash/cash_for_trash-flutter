import 'package:cash_for_trash/core/di/service_locator.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/address/presentation/bloc/address_bloc.dart' as address;
import 'package:cash_for_trash/features/address/presentation/screens/address_screen.dart';
import 'package:cash_for_trash/features/auth/forgot-password/presentation/screens/forgot_password.dart';
import 'package:cash_for_trash/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:cash_for_trash/features/auth/login/presentation/screens/login_screen.dart';
import 'package:cash_for_trash/features/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:cash_for_trash/features/auth/otp/presentation/screens/otp_screen.dart';
import 'package:cash_for_trash/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:cash_for_trash/features/auth/register/presentation/screens/register_screen.dart';
import 'package:cash_for_trash/features/auth/reset_password/presentation/screens/reset_password.dart';
import 'package:cash_for_trash/features/home/presentation/bloc/home_bloc.dart';
import 'package:cash_for_trash/features/maps/data/model/selected_location_model.dart';
import 'package:cash_for_trash/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/address_form_screen.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/maps_screen.dart';
import 'package:cash_for_trash/features/onboarding/presentation/screens/onbording_screen.dart';
import 'package:cash_for_trash/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cash_for_trash/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/request_collection_screen.dart';
import 'package:cash_for_trash/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:cash_for_trash/features/splash/presentation/screens/splash_screen.dart';
import 'package:cash_for_trash/features/worker/root_worker.dart';
import 'package:cash_for_trash/features/worker/home_worker/presentation/bloc/home_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/home_worker/presentation/bloc/home_worker_event.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/availability_worker/presentation/bloc/availability_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/presentation/bloc/earnings_worker_bloc.dart';
import 'package:cash_for_trash/root/root.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouterGenerator {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
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
        path: AppRoutes.workerHomeScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<HomeWorkerBloc>()..add(const GetHomeWorkerDataEvent()),
            ),
            BlocProvider(create: (context) => sl<CollectionRequestsWorkerBloc>()),
            BlocProvider(create: (context) => sl<AvailabilityWorkerBloc>()),
            BlocProvider(create: (context) => sl<EarningsWorkerBloc>()),
            BlocProvider(create: (context) => sl<ProfileBloc>()),
          ],
          child: const RootWorker(),
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
          create: (context) => sl<RequestCollectionBloc>()
            ..add(const GetGarbageTypesEvent())
            ..add(const GetAddressesEvent()),
          child: const RequestCollectionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.mapsScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final initialLatLng = extra?['initialLatLng'] as LatLng?;
          return BlocProvider(
            create: (context) => sl<MapsBloc>()
              ..add(MapsInitializedEvent(initialLatLng: initialLatLng)),
            child: const MapsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addressesScreen,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              sl<address.AddressBloc>()..add(const address.GetAddressesEvent()),
          child: const AddressScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addressFormScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final selectedLocation =
              args['selectedLocation'] as SelectedLocationModel;
          final existingAddress = args['existingAddress'] as AddressModel?;
          return BlocProvider(
            create: (context) => sl<MapsBloc>(),
            child: AddressFormScreen(
              selectedLocation: selectedLocation,
              existingAddress: existingAddress,
            ),
          );
        },
      ),
    ],
  );
}
