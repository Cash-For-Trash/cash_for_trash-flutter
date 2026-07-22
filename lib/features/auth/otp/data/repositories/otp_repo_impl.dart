import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/auth/otp/data/models/otp_resend_model.dart';
import 'package:cash_for_trash/features/auth/otp/data/models/otp_verify_model.dart';
import 'package:cash_for_trash/features/auth/otp/domain/repositories/otp_repository.dart';
import 'package:dartz/dartz.dart';

class OtpRepoImpl implements OtpRepository {
  final ApiConsumer apiConsumer;

  OtpRepoImpl({required this.apiConsumer});

  @override
  Future<Either<String, OtpVerifyModel>> verifyOtp(
    String email,
    String otp,
  ) async {
    return await apiConsumer.post<OtpVerifyModel>(
      EndPoint.verifyOtp,
      data: {'email': email, 'otp': otp},
      fromJson: OtpVerifyModel.fromJson,
    );
  }

  @override
  Future<Either<String, OtpResendModel>> resendOtp(String email) async {
    return await apiConsumer.post<OtpResendModel>(
      EndPoint.resendOtp,
      data: {'email': email},
      fromJson: OtpResendModel.fromJson,
    );
  }
}
