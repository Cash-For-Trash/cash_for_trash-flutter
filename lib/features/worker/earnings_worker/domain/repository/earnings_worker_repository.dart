import 'package:cash_for_trash/features/worker/earnings_worker/data/model/earnings_worker_model.dart';
import 'package:dartz/dartz.dart';

abstract class EarningsWorkerRepository {
  Future<Either<String, EarningsWorkerModel>> getWorkerEarnings();
}
