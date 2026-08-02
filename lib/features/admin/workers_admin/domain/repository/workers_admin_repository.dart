import 'package:cash_for_trash/features/admin/workers_admin/data/model/worker_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class WorkersAdminRepository {
  Future<Either<String, List<WorkerAdminModel>>> getWorkers({
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<String, WorkerAdminModel>> getWorkerDetail(String userId);

  Future<Either<String, String>> approveWorker(String workerId);
}
