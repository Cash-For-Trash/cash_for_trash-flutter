import 'package:cash_for_trash/features/worker/availability_worker/data/model/availability_worker_model.dart';
import 'package:dartz/dartz.dart';

abstract class AvailabilityWorkerRepository {
  Future<Either<String, List<AvailabilityWorkerModel>>> getMyAvailabilities();

  Future<Either<String, AvailabilityWorkerModel>> createAvailability(AvailabilityWorkerModel availability);

  Future<Either<String, AvailabilityWorkerModel>> updateAvailability(
    String id,
    AvailabilityWorkerModel availability,
  );

  Future<Either<String, List<Map<String, dynamic>>>> getServiceAreas();
}
