import 'package:cash_for_trash/core/localization/locale_cubit.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/dio_consumer.dart';
import 'package:cash_for_trash/core/theme/theme_cubit.dart';
import 'package:cash_for_trash/features/address/data/repository/address_repository_impl.dart';
import 'package:cash_for_trash/features/address/domain/repository/address_repository.dart';
import 'package:cash_for_trash/features/address/presentation/bloc/address_bloc.dart';
import 'package:cash_for_trash/features/auth/login/data/repositories/login_repo_impl.dart';
import 'package:cash_for_trash/features/auth/login/domain/repositories/login_repository.dart';
import 'package:cash_for_trash/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:cash_for_trash/features/auth/otp/data/repositories/otp_repo_impl.dart';
import 'package:cash_for_trash/features/auth/otp/domain/repositories/otp_repository.dart';
import 'package:cash_for_trash/features/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:cash_for_trash/features/auth/register/data/repositories/register_repo_impl.dart';
import 'package:cash_for_trash/features/auth/register/domain/repositories/register_repository.dart';
import 'package:cash_for_trash/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:cash_for_trash/features/home/data/repository/home_repository_impl.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';
import 'package:cash_for_trash/features/home/presentation/bloc/home_bloc.dart';
import 'package:cash_for_trash/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cash_for_trash/features/splash/data/repositories/splash_repo_impl.dart';
import 'package:cash_for_trash/features/splash/domain/repositories/splash_repository.dart';
import 'package:cash_for_trash/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:cash_for_trash/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:cash_for_trash/features/profile/domain/repositories/profile_repository.dart';
import 'package:cash_for_trash/features/request_collection/data/repositories/request_collection_repository_impl.dart';
import 'package:cash_for_trash/features/request_collection/domain/repositories/request_collection_repository.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/maps/data/repository/maps_repository_impl.dart';
import 'package:cash_for_trash/features/maps/domain/repository/maps_repository.dart';
import 'package:cash_for_trash/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:cash_for_trash/features/worker/home_worker/data/repository/home_worker_repository_impl.dart';
import 'package:cash_for_trash/features/worker/home_worker/domain/repository/home_worker_repository.dart';
import 'package:cash_for_trash/features/worker/home_worker/presentation/bloc/home_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/repository/collection_requests_worker_repository_impl.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/domain/repository/collection_requests_worker_repository.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/availability_worker/data/repository/availability_worker_repository_impl.dart';
import 'package:cash_for_trash/features/worker/availability_worker/domain/repository/availability_worker_repository.dart';
import 'package:cash_for_trash/features/worker/availability_worker/presentation/bloc/availability_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/data/repository/earnings_worker_repository_impl.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/domain/repository/earnings_worker_repository.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/presentation/bloc/earnings_worker_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  sl.registerLazySingleton<CacheHelper>(() => cacheHelper);

  // External
  sl.registerLazySingleton(() => Dio());

  // Remote package
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));

  // Core Cubits
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  // Splash Feature
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepoImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerFactory<SplashBloc>(() => SplashBloc(repository: sl()));

  // Profile Feature
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(repository: sl()));

  // Home Feature
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerFactory<HomeBloc>(() => HomeBloc(repository: sl()));

  // Auth Feature
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepoImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerRepository: sl()),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepoImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerFactory<LoginBloc>(() => LoginBloc(loginRepository: sl()));
  sl.registerLazySingleton<OtpRepository>(() => OtpRepoImpl(apiConsumer: sl()));
  sl.registerFactory<OtpBloc>(() => OtpBloc(otpRepository: sl()));

  // Maps Feature
  sl.registerLazySingleton<MapsRepository>(
    () => MapsRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<MapsBloc>(() => MapsBloc(repository: sl()));

  // Address Feature
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<AddressBloc>(
    () => AddressBloc(repository: sl()),
  );

  // Request Collection Feature
  sl.registerLazySingleton<RequestCollectionRepository>(
    () => RequestCollectionRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<RequestCollectionBloc>(
    () => RequestCollectionBloc(repository: sl()),
  );

  sl.registerLazySingleton<HomeWorkerRepository>(
    () => HomeWorkerRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<HomeWorkerBloc>(
    () => HomeWorkerBloc(repository: sl()),
  );

  sl.registerLazySingleton<CollectionRequestsWorkerRepository>(
    () => CollectionRequestsWorkerRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<CollectionRequestsWorkerBloc>(
    () => CollectionRequestsWorkerBloc(repository: sl()),
  );

  sl.registerLazySingleton<AvailabilityWorkerRepository>(
    () => AvailabilityWorkerRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<AvailabilityWorkerBloc>(
    () => AvailabilityWorkerBloc(repository: sl()),
  );

  sl.registerLazySingleton<EarningsWorkerRepository>(
    () => EarningsWorkerRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory<EarningsWorkerBloc>(
    () => EarningsWorkerBloc(repository: sl()),
  );
}
