import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/garbage_weight_worker_model.dart';
import 'package:dartz/dartz.dart';

abstract class CollectionRequestsWorkerRepository {
  Future<Either<String, List<CollectionRequestWorkerModel>>> getAssignedCollectionRequests({String? status});

  Future<Either<String, CollectionRequestWorkerModel>> updateCollectionRequestStatus(
    String requestId,
    String status,
  );

  Future<Either<String, CollectionRequestWorkerModel>> submitGarbageWeights(
    String requestId,
    List<GarbageWeightWorkerModel> weights,
  );
}
