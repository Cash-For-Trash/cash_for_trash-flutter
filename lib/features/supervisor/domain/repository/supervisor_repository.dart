import 'package:dartz/dartz.dart';
import '../../data/model/create_worker_request_model.dart';
import '../../data/model/worker_supervisor_model.dart';

abstract class SupervisorRepository {
  Future<Either<String, SupervisorWorkersResponseModel>> getSupervisorWorkers({
    int page = 1,
    int pageSize = 10,
  });
  Future<Either<String, void>> createWorker(CreateWorkerRequestModel request);
}
