import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/auth/register/data/models/register_model.dart';
import 'package:cash_for_trash/features/auth/register/domain/repositories/register_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterRepoImpl implements RegisterRepository {
  final ApiConsumer apiConsumer;
  final CacheHelper cacheHelper;
  RegisterRepoImpl({required this.apiConsumer, required this.cacheHelper});

  @override
  Future<Either<String, RegisterModel>> register(
    String firstName,
    String lastName,
    String phone,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    final result = await apiConsumer.post<RegisterModel>(
      EndPoint.register,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'mobile': phone,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'role': role,
      },
      fromJson: RegisterModel.fromJson,
    );

    result.fold(
      (error) {},
      (success) async {
        await CacheHelper.saveData(key: ApiKey.firstName, value: firstName);
        await CacheHelper.saveData(key: ApiKey.lastName, value: lastName);
        await CacheHelper.saveData(key: ApiKey.email, value: email);
        await CacheHelper.saveData(key: ApiKey.password, value: password);
        await CacheHelper.saveData(key: 'mobile', value: phone);
        await CacheHelper.saveData(key: ApiKey.role, value: role);
      },
    );

    return result;
  }
}
