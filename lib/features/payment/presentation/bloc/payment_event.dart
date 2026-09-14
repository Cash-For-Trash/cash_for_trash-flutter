import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class  InitiatePaymentCashEvent extends PaymentEvent {
  final String collectionRequestId;

  const InitiatePaymentCashEvent(this.collectionRequestId);

  @override
  List<Object?> get props => [collectionRequestId];
}

class InitiatePaymentCardEvent extends PaymentEvent {
  final String collectionRequestId;

  const InitiatePaymentCardEvent(this.collectionRequestId);

  @override
  List<Object?> get props => [collectionRequestId];
}
