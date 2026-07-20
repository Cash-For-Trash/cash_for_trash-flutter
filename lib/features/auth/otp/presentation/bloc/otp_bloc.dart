import 'package:bloc/bloc.dart';
import 'package:cash_for_trash/features/auth/otp/data/models/otp_resend_model.dart';
import 'package:cash_for_trash/features/auth/otp/data/models/otp_verify_model.dart';
import 'package:cash_for_trash/features/auth/otp/domain/repositories/otp_repository.dart';
import 'package:equatable/equatable.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpRepository otpRepository;

  OtpBloc({required this.otpRepository}) : super(OtpInitial()) {
    on<VerifyOtpPressed>((event, emit) async {
      emit(OtpVerifyLoading());
      final result = await otpRepository.verifyOtp(event.email, event.otp);
      
      result.fold(
        (error) => emit(OtpVerifyFailure(error: error)),
        (model) => emit(OtpVerifySuccess(verifyModel: model)),
      );
    });

    on<ResendOtpPressed>((event, emit) async {
      emit(OtpResendLoading());
      final result = await otpRepository.resendOtp(event.email);
      
      result.fold(
        (error) => emit(OtpResendFailure(error: error)),
        (model) => emit(OtpResendSuccess(resendModel: model)),
      );
    });
  }
}
