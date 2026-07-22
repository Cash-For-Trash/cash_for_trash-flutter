import 'package:cash_for_trash/features/auth/login/data/models/login_model.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<String, LoginModel>> login(String email, String password);
}
