import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either<String, bool>> initiatePayment(String collectionRequestId);

  Future<Either<String, String>> initialCardPayment(String collectionRequestId);
}
