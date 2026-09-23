import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/worker/availability_worker/data/model/availability_worker_model.dart';
import 'package:cash_for_trash/features/worker/availability_worker/domain/repository/availability_worker_repository.dart';
import 'package:dartz/dartz.dart';

class AvailabilityWorkerRepositoryImpl implements AvailabilityWorkerRepository {
  final ApiConsumer apiConsumer;

  AvailabilityWorkerRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<AvailabilityWorkerModel>>> getMyAvailabilities() async {
    final workerId = CacheHelper.getDataString(key: 'selected_worker_id');
    final String path = (workerId != null && workerId.isNotEmpty)
        ? EndPoint.availabilitiesMySupervisor(workerId)
        : EndPoint.myAvailabilities;

    final result = await apiConsumer.get<Map<String, dynamic>>(path);
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList
            .map((item) => AvailabilityWorkerModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, AvailabilityWorkerModel>> createAvailability(
    AvailabilityWorkerModel availability,
  ) async {
    final workerId = CacheHelper.getDataString(key: 'selected_worker_id');
    final String path = (workerId != null && workerId.isNotEmpty)
        ? EndPoint.availabilitiesCreateSupervisor(workerId)
        : EndPoint.availabilities;

    return await apiConsumer.post<AvailabilityWorkerModel>(
      path,
      data: availability.toJson(),
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return AvailabilityWorkerModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, AvailabilityWorkerModel>> updateAvailability(
    String id,
    AvailabilityWorkerModel availability,
  ) async {
    final workerId = CacheHelper.getDataString(key: 'selected_worker_id');
    final String path = (workerId != null && workerId.isNotEmpty)
        ? EndPoint.availabilitiesUpdateSupervisor(workerId, id)
        : '${EndPoint.availabilities}/$id';

    return await apiConsumer.patch<AvailabilityWorkerModel>(
      path,
      data: availability.toJson(),
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return AvailabilityWorkerModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getServiceAreas() async {
    final result = await apiConsumer.get<Map<String, dynamic>>(EndPoint.areas);
    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List ? json['data'] as List : [];
        final list = rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        return Right(list);
      },
    );
  }
}
