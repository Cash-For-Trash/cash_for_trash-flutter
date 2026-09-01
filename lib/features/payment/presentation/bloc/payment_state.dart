import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitialState extends PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentSuccessState extends PaymentState {}

class PaymentErrorState extends PaymentState {
  final String errorMessage;

  const PaymentErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
