import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:equatable/equatable.dart';

abstract class CollectionRequestsWorkerState extends Equatable {
  const CollectionRequestsWorkerState();

  @override
  List<Object?> get props => [];
}

class CollectionRequestsWorkerInitialState extends CollectionRequestsWorkerState {}

class CollectionRequestsWorkerLoadingState extends CollectionRequestsWorkerState {}

class CollectionRequestsWorkerLoadedState extends CollectionRequestsWorkerState {
  final List<CollectionRequestWorkerModel> requests;
  final String activeTab;

  const CollectionRequestsWorkerLoadedState({
    required this.requests,
    this.activeTab = 'active',
  });

  @override
  List<Object?> get props => [requests, activeTab];
}

class CollectionRequestsWorkerUpdatingState extends CollectionRequestsWorkerState {}

class CollectionRequestsWorkerSuccessState extends CollectionRequestsWorkerState {
  final String message;
  final CollectionRequestWorkerModel updatedRequest;

  const CollectionRequestsWorkerSuccessState({
    required this.message,
    required this.updatedRequest,
  });

  @override
  List<Object?> get props => [message, updatedRequest];
}

class CollectionRequestsWorkerErrorState extends CollectionRequestsWorkerState {
  final String errorMessage;

  const CollectionRequestsWorkerErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
