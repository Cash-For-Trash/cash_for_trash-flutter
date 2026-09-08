import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/core/services/remote/payment_service.dart';
import 'package:cash_for_trash/features/payment/data/model/payment_model.dart';
import 'package:cash_for_trash/features/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiConsumer apiConsumer;
  final PaymentService paymentService;

  PaymentRepositoryImpl({required this.apiConsumer, required this.paymentService});

  @override
  Future<Either<String, bool>> initiatePayment(
      String collectionRequestId,
      ) async {
    return await apiConsumer.post<bool>(
      EndPoint.initiatePayment(collectionRequestId),
      queryParameters: {
        "payment_method": "CASH"
      },
      fromJson: (_) => true,
    );
  }

  @override
  Future<Either<String, String>> initialCardPayment(String collectionRequestId) async {
    final createCashPaymentRequest = await apiConsumer.post<PaymentModel>(
        EndPoint.initiatePayment(collectionRequestId),
        queryParameters: {
          "payment_method": "CARD"
        },
        fromJson: (json) {
          final dataObj = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
          return PaymentModel.fromJson(dataObj);
        }
    );

    if (createCashPaymentRequest.isLeft()) {
      return Left(createCashPaymentRequest.swap().getOrElse(() => 'Unknown error'));
    }

    final paymentModel =
    createCashPaymentRequest.getOrElse(() => throw Exception());

    if (paymentModel.checkoutUrl.isNotEmpty) {
      return Right(paymentModel.checkoutUrl);
    }
    return const Left('URL Not Found');
  }
}