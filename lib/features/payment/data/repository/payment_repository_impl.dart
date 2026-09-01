import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiConsumer apiConsumer;

  PaymentRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, bool>> initiatePayment(
    String collectionRequestId,
  ) async {
    return await apiConsumer.post<bool>(
      EndPoint.initiatePayment(collectionRequestId),
      fromJson: (_) => true,
    );
  }
}
