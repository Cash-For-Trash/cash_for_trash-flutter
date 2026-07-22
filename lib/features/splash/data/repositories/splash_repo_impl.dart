import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/splash/domain/repositories/splash_repository.dart';
import 'package:cash_for_trash/features/splash/data/models/verify_token_response_model.dart';
import 'package:dartz/dartz.dart';

class SplashRepoImpl implements SplashRepository {
  final ApiConsumer apiConsumer;
  final CacheHelper cacheHelper;
  
  SplashRepoImpl({required this.apiConsumer, required this.cacheHelper});

  @override
  Future<Either<String, VerifyTokenResponseModel>> checkToken() async {
    final result = await apiConsumer.post<VerifyTokenResponseModel>(
      EndPoint.checkToken,
      fromJson: VerifyTokenResponseModel.fromJson,
    );

    return result;
  }
}
