import 'package:cash_for_trash/features/worker/home_worker/data/model/home_worker_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeWorkerRepository {
  Future<Either<String, HomeWorkerModel>> getHomeWorkerData();
}
