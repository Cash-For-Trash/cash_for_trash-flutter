import 'package:cash_for_trash/features/payment/domain/repository/payment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc({required this.repository}) : super(PaymentInitialState()) {
    on<InitiatePaymentCashEvent>(_onInitiatePayment);
    on<InitiatePaymentCardEvent>(_onInitiatePaymentCard);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentCashEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoadingState());
    emit(PaymentSuccessState());
    // final result = await repository.initiatePayment(event.collectionRequestId);
    // result.fold(
    //   (error) => emit(PaymentErrorState(error)),
    //   (_) => emit(PaymentSuccessState()),
    // );
  }

  Future<void> _onInitiatePaymentCard(
    InitiatePaymentCardEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoadingState());
    final result = await repository.initialCardPayment(event.collectionRequestId);
    result.fold(
      (error) => emit(PaymentErrorState(error)),
      (url) => emit(PaymentInitiatePaymentCardSuccessState(url)),
    );
  }
}
