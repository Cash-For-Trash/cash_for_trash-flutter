part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpPressed extends OtpEvent {
  final String email;
  final String otp;

  const VerifyOtpPressed({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class ResendOtpPressed extends OtpEvent {
  final String email;

  const ResendOtpPressed({required this.email});

  @override
  List<Object> get props => [email];
}
