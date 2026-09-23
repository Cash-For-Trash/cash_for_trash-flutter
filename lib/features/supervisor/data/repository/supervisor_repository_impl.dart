import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/supervisor_repository.dart';
import '../model/create_worker_request_model.dart';
import '../model/worker_supervisor_model.dart';

class SupervisorRepositoryImpl implements SupervisorRepository {
  final ApiConsumer apiConsumer;

  SupervisorRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, SupervisorWorkersResponseModel>> getSupervisorWorkers({
    int page = 1,
    int pageSize = 10,
  }) async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.supervisorWorkers,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return result.fold((error) => Left(error), (json) {
      final responseModel = SupervisorWorkersResponseModel.fromJson(json);
      return Right(responseModel);
    });
  }

  @override
  Future<Either<String, void>> createWorker(
    CreateWorkerRequestModel request,
  ) async {
    final result = await apiConsumer.post<Map<String, dynamic>>(
      EndPoint.supervisorWorkers,
      data: request.toJson(),
    );
    return result.fold((error) => Left(error), (_) => const Right(null));
  }
}
