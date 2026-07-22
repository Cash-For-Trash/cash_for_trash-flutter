import 'package:cash_for_trash/features/splash/data/models/verify_token_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class SplashRepository {
  Future<Either<String, VerifyTokenResponseModel>> checkToken();
}
