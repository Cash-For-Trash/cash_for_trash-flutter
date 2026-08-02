import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/workers_admin_repository.dart';
import '../model/worker_admin_model.dart';

class WorkersAdminRepositoryImpl implements WorkersAdminRepository {
  final ApiConsumer apiConsumer;

  WorkersAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<WorkerAdminModel>>> getWorkers({
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.adminWorkers,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return result.fold(
      (error) => Left(error),
      (json) {
        List rawList = [];
        if (json['data'] is Map && (json['data'] as Map)['data'] is List) {
          rawList = (json['data'] as Map)['data'] as List;
        } else if (json['data'] is List) {
          rawList = json['data'] as List;
        } else if (json['workers'] is List) {
          rawList = json['workers'] as List;
        }

        final list = rawList
            .map((item) =>
                WorkerAdminModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, WorkerAdminModel>> getWorkerDetail(
      String userId) async {
    return await apiConsumer.get<WorkerAdminModel>(
      '${EndPoint.adminWorkers}/$userId',
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return WorkerAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, String>> approveWorker(String workerId) async {
    final result = await apiConsumer.patch<Map<String, dynamic>>(
      '${EndPoint.workerApprove}/$workerId/approve',
    );
    return result.fold(
      (error) => Left(error),
      (json) => Right(json['message']?.toString() ?? 'Worker approved successfully'),
    );
  }
}
