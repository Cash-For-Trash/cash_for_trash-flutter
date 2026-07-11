import 'package:cash_for_trash/core/localization/locale_cubit.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/dio_consumer.dart';
import 'package:cash_for_trash/core/theme/theme_cubit.dart';
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
}

