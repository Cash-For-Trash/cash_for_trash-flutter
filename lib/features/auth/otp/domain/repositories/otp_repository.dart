import 'package:cash_for_trash/features/auth/otp/data/models/otp_resend_model.dart';
import 'package:cash_for_trash/features/auth/otp/data/models/otp_verify_model.dart';
import 'package:dartz/dartz.dart';

abstract class OtpRepository {
  Future<Either<String, OtpVerifyModel>> verifyOtp(String email, String otp);
  Future<Either<String, OtpResendModel>> resendOtp(String email);
}
