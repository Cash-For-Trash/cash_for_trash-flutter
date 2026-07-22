import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/auth/login/data/models/login_model.dart';
import 'package:cash_for_trash/features/auth/login/domain/repositories/login_repository.dart';
import 'package:dartz/dartz.dart';

class LoginRepoImpl implements LoginRepository {
  final ApiConsumer apiConsumer;
  final CacheHelper cacheHelper;

  LoginRepoImpl({required this.apiConsumer, required this.cacheHelper});

  @override
  Future<Either<String, LoginModel>> login(
    String email,
    String password,
  ) async {
    final result = await apiConsumer.post<LoginModel>(
      EndPoint.login,
      data: {'email': email, 'password': password},
      fromJson: LoginModel.fromJson,
    );

    result.fold((error) {}, (success) async {
      await CacheHelper.saveSecretData(
        key: ApiKey.accessToken,
        value: success.data.accessToken,
      );
      await CacheHelper.saveSecretData(
        key: ApiKey.refreshToken,
        value: success.data.refreshToken,
      );
      await CacheHelper.saveData(
        key: ApiKey.firstName,
        value: success.data.user.firstName,
      );
      await CacheHelper.saveData(
        key: ApiKey.lastName,
        value: success.data.user.lastName,
      );
      await CacheHelper.saveData(
        key: ApiKey.email,
        value: success.data.user.email,
      );
      await CacheHelper.saveData(
        key: ApiKey.role,
        value: success.data.user.role,
      );
      await CacheHelper.saveSecretData(
        key: ApiKey.user,
        value: success.data.user.userId.toString(),
      );
    });

    return result;
  }
}
