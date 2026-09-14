import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/garbage_weight_worker_model.dart';
import 'package:equatable/equatable.dart';

abstract class CollectionRequestsWorkerEvent extends Equatable {
  const CollectionRequestsWorkerEvent();

  @override
  List<Object?> get props => [];
}

class GetAssignedCollectionRequestsEvent extends CollectionRequestsWorkerEvent {
  final String? status;

  const GetAssignedCollectionRequestsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class UpdateCollectionRequestStatusEvent extends CollectionRequestsWorkerEvent {
  final String requestId;
  final String status;

  const UpdateCollectionRequestStatusEvent({
    required this.requestId,
    required this.status,
  });

  @override
  List<Object?> get props => [requestId, status];
}

class GetWorkerCollectionRequestDetailsEvent extends CollectionRequestsWorkerEvent {
  final String requestId;

  const GetWorkerCollectionRequestDetailsEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class SubmitGarbageWeightsEvent extends CollectionRequestsWorkerEvent {
  final String requestId;
  final List<GarbageWeightWorkerModel> weights;

  const SubmitGarbageWeightsEvent({
    required this.requestId,
    required this.weights,
  });

  @override
  List<Object?> get props => [requestId, weights];
}
