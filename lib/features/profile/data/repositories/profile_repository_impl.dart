import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiConsumer apiConsumer;
  final CacheHelper cacheHelper;

  ProfileRepositoryImpl({
    required this.apiConsumer,
    required this.cacheHelper,
  });

  @override
  Future<Either<String, void>> logout() async {
    final result = await apiConsumer.post(
      EndPoint.logout,
    );

    await CacheHelper.removeAllSecretData();
    await cacheHelper.clearUserData();

    return result.fold(
      (error) => Left(error),
      (_) => const Right(null),
    );
  }
}
