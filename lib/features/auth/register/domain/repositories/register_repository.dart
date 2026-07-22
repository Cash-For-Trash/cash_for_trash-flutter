import 'package:cash_for_trash/features/auth/register/data/models/register_model.dart';
import 'package:dartz/dartz.dart';

abstract class RegisterRepository {
  Future<Either<String, RegisterModel>> register(
    String firstName,
    String lastName,
    String phone,
    String email,
    String password,
    String confirmPassword,
    String role,
  );
}
