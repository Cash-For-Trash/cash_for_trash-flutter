import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final String collectionRequestId;

  const InitiatePaymentEvent(this.collectionRequestId);

  @override
  List<Object?> get props => [collectionRequestId];
}
