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
    final result = await apiConsumer.get<Map<String, dynamic>>(EndPoint.myAvailabilities);
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
    return await apiConsumer.post<AvailabilityWorkerModel>(
      EndPoint.availabilities,
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
    return await apiConsumer.patch<AvailabilityWorkerModel>(
      '${EndPoint.availabilities}/$id',
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
