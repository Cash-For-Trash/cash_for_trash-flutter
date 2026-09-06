import 'dart:developer';

import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/core/services/remote/payment_service.dart';
import 'package:cash_for_trash/features/payment/data/model/payment_model.dart';
import 'package:cash_for_trash/features/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiConsumer apiConsumer;
  final PaymentService paymentService;

  PaymentRepositoryImpl({
    required this.apiConsumer,
    required this.paymentService,
  });

  @override
  Future<Either<String, bool>> initiatePayment(
    String collectionRequestId,
  ) async {
    return await apiConsumer.post<bool>(
      EndPoint.initiatePayment(collectionRequestId),
      fromJson: (_) => true,
    );
  }

  @override
  Future<Either<String, String>> cardPayment(String collectionRequestId) async {
    final createCashPaymentRequest = await apiConsumer.post<PaymentModel>(
      EndPoint.initiatePayment(collectionRequestId),
      queryParameters: {"payment_method": "CARD"},
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
        return PaymentModel.fromJson(dataObj);
      },
    );
    if (createCashPaymentRequest.isLeft()) {
      return Left(
        createCashPaymentRequest.swap().getOrElse(
          () => 'Failed to initiate payment',
        ),
      );
    }
    final paymentModel = createCashPaymentRequest.getOrElse(
      () => throw Exception(),
    );
    if (paymentModel.clientSecret.isEmpty) {
      return const Left('Invalid client secret received from server.');
    }
    final payResult = await paymentService.initPayment(
      paymentModel.clientSecret,
    );
    if (payResult == "Success") {
      return const Right("Success");
    }

    try {
      final historyResult = await apiConsumer.get<PaymentHistoryResponseModel>(
        EndPoint.myPayments,
        fromJson: (json) => PaymentHistoryResponseModel.fromJson(json),
      );

      final isSuccessfulOnBackend = historyResult.fold(
        (_) => false,
        (response) {
          final payment = response.data.firstWhere(
            (p) =>
                (paymentModel.paymentId.isNotEmpty &&
                    p.paymentId == paymentModel.paymentId) ||
                (paymentModel.paymobIntentionId.isNotEmpty &&
                    p.paymobIntentionId == paymentModel.paymobIntentionId),
            orElse: () => const PaymentModel(
              paymentId: '',
              paymentMethod: '',
              paymentStatus: '',
              paymentAmount: '0',
              paymobIntentionId: '',
              clientSecret: '',
              checkoutUrl: '',
            ),
          );
          final status = payment.paymentStatus.toUpperCase();
          return status == 'COMPLETED' ||
              status == 'SUCCESS' ||
              status == 'SUCCESSFUL' ||
              status == 'PAID';
        },
      );

      if (isSuccessfulOnBackend) {
        return const Right("Success");
      }
    } catch (e) {
      log("Error verifying payment status on backend: $e");
    }

    return Left(payResult);
  }
}
