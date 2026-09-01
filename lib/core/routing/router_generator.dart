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
import 'package:cash_for_trash/features/admin/root_admin.dart';
import 'package:cash_for_trash/features/admin/home_admin/presentation/bloc/home_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/workers_admin/presentation/bloc/workers_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/workers_admin/presentation/bloc/workers_admin_event.dart';
import 'package:cash_for_trash/features/admin/workers_admin/presentation/screens/worker_detail_admin_screen.dart';
import 'package:cash_for_trash/features/admin/customers_admin/presentation/bloc/customers_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/areas_admin/presentation/bloc/areas_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/areas_admin/data/model/area_admin_model.dart';
import 'package:cash_for_trash/features/admin/areas_admin/presentation/screens/area_form_admin_screen.dart';
import 'package:cash_for_trash/features/admin/availabilities_admin/presentation/bloc/availabilities_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/garbage_types_admin/presentation/bloc/garbage_types_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/garbage_types_admin/data/model/garbage_type_admin_model.dart';
import 'package:cash_for_trash/features/admin/garbage_types_admin/presentation/screens/garbage_type_form_admin_screen.dart';
import 'package:cash_for_trash/features/admin/rewards_admin/presentation/bloc/rewards_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/rewards_admin/data/model/reward_admin_model.dart';
import 'package:cash_for_trash/features/admin/rewards_admin/presentation/screens/reward_form_admin_screen.dart';
import 'package:cash_for_trash/features/admin/redemptions_admin/presentation/bloc/redemptions_admin_bloc.dart';
import 'package:cash_for_trash/features/admin/pricing_admin/presentation/bloc/pricing_admin_bloc.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:cash_for_trash/features/payment/presentation/screens/card_payment_screen.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:cash_for_trash/features/rewards/presentation/screens/rewards_screen.dart';
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
      GoRoute(
        path: AppRoutes.adminHomeScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<HomeAdminBloc>()),
            BlocProvider(create: (_) => sl<WorkersAdminBloc>()),
            BlocProvider(create: (_) => sl<CustomersAdminBloc>()),
            BlocProvider(create: (_) => sl<AreasAdminBloc>()),
            BlocProvider(create: (_) => sl<AvailabilitiesAdminBloc>()),
            BlocProvider(create: (_) => sl<GarbageTypesAdminBloc>()),
            BlocProvider(create: (_) => sl<RewardsAdminBloc>()),
            BlocProvider(create: (_) => sl<RedemptionsAdminBloc>()),
            BlocProvider(create: (_) => sl<PricingAdminBloc>()),
            BlocProvider(create: (_) => sl<ProfileBloc>()),
          ],
          child: const RootAdmin(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminAreaFormScreen,
        builder: (context, state) {
          final existingArea = state.extra as AreaAdminModel?;
          return BlocProvider(
            create: (_) => sl<AreasAdminBloc>(),
            child: AreaFormAdminScreen(existingArea: existingArea),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminGarbageTypeFormScreen,
        builder: (context, state) {
          final existingItem = state.extra as GarbageTypeAdminModel?;
          return BlocProvider(
            create: (_) => sl<GarbageTypesAdminBloc>(),
            child: GarbageTypeFormAdminScreen(existingItem: existingItem),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminRewardFormScreen,
        builder: (context, state) {
          final existingReward = state.extra as RewardAdminModel?;
          return BlocProvider(
            create: (_) => sl<RewardsAdminBloc>(),
            child: RewardFormAdminScreen(existingReward: existingReward),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminWorkerDetailScreen,
        builder: (context, state) {
          final userId = state.extra as String;
          return BlocProvider(
            create: (_) => sl<WorkersAdminBloc>()
              ..add(GetWorkerDetailAdminEvent(userId)),
            child: WorkerDetailAdminScreen(userId: userId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.rewardsScreen,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              sl<RewardsBloc>()..add(const GetRewardsEvent()),
          child: const RewardsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.cardPaymentScreen,
        builder: (context, state) {
          final collectionRequestId = state.extra as String;
          return BlocProvider(
            create: (context) => sl<PaymentBloc>(),
            child: CardPaymentScreen(
              collectionRequestId: collectionRequestId,
            ),
          );
        },
      ),
    ],
  );
}
