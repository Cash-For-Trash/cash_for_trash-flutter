import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/garbage_weight_worker_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/domain/repository/collection_requests_worker_repository.dart';
import 'package:dartz/dartz.dart';

class CollectionRequestsWorkerRepositoryImpl implements CollectionRequestsWorkerRepository {
  final ApiConsumer apiConsumer;

  CollectionRequestsWorkerRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<CollectionRequestWorkerModel>>> getAssignedCollectionRequests({
    String? status,
  }) async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.collectionRequests,
      queryParameters: status != null ? {'status': status} : null,
    );

    return result.fold(
      (error) => Left(error),
      (json) {
        final rawList = json['data'] is List
            ? json['data'] as List
            : (json['requests'] is List ? json['requests'] as List : []);

        final list = rawList
            .map((item) => CollectionRequestWorkerModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();

        return Right(list);
      },
    );
  }

  @override
  Future<Either<String, CollectionRequestWorkerModel>> updateCollectionRequestStatus(
    String requestId,
    String status,
  ) async {
    return await apiConsumer.patch<CollectionRequestWorkerModel>(
      '${EndPoint.collectionRequests}/$requestId/status',
      data: {ApiKey.status: status},
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return CollectionRequestWorkerModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, CollectionRequestWorkerModel>> submitGarbageWeights(
    String requestId,
    List<GarbageWeightWorkerModel> weights,
  ) async {
    return await apiConsumer.post<CollectionRequestWorkerModel>(
      '${EndPoint.collectionRequests}/$requestId/collect',
      data: {
        ApiKey.status: 'COLLECTED',
        ApiKey.weights: weights.map((w) => w.toJson()).toList(),
      },
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return CollectionRequestWorkerModel.fromJson(dataObj);
      },
    );
  }
}
