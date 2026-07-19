import 'package:cash_for_trash/core/localization/locale_cubit.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/dio_consumer.dart';
import 'package:cash_for_trash/core/theme/theme_cubit.dart';
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
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginRepository: sl()),
  );
  sl.registerLazySingleton<OtpRepository>(
    () => OtpRepoImpl(apiConsumer: sl()),
  );
  sl.registerFactory<OtpBloc>(
    () => OtpBloc(otpRepository: sl()),
  );
}
