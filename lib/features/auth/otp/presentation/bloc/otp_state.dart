part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitial extends OtpState {}

final class OtpVerifyLoading extends OtpState {}

final class OtpVerifySuccess extends OtpState {
  final OtpVerifyModel verifyModel;

  const OtpVerifySuccess({required this.verifyModel});

  @override
  List<Object> get props => [verifyModel];
}

final class OtpVerifyFailure extends OtpState {
  final String error;

  const OtpVerifyFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class OtpResendLoading extends OtpState {}

final class OtpResendSuccess extends OtpState {
  final OtpResendModel resendModel;

  const OtpResendSuccess({required this.resendModel});

  @override
  List<Object> get props => [resendModel];
}

final class OtpResendFailure extends OtpState {
  final String error;

  const OtpResendFailure({required this.error});

  @override
  List<Object> get props => [error];
}
