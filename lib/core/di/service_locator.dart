import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/dio_consumer.dart';
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
}
