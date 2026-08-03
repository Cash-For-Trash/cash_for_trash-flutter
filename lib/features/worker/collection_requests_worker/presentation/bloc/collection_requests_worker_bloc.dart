import 'package:cash_for_trash/features/worker/collection_requests_worker/domain/repository/collection_requests_worker_repository.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_event.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionRequestsWorkerBloc
    extends Bloc<CollectionRequestsWorkerEvent, CollectionRequestsWorkerState> {
  final CollectionRequestsWorkerRepository repository;

  CollectionRequestsWorkerBloc({required this.repository})
      : super(CollectionRequestsWorkerInitialState()) {
    on<GetAssignedCollectionRequestsEvent>(_onGetAssignedCollectionRequests);
    on<UpdateCollectionRequestStatusEvent>(_onUpdateCollectionRequestStatus);
    on<SubmitGarbageWeightsEvent>(_onSubmitGarbageWeights);
  }

  Future<void> _onGetAssignedCollectionRequests(
    GetAssignedCollectionRequestsEvent event,
    Emitter<CollectionRequestsWorkerState> emit,
  ) async {
    emit(CollectionRequestsWorkerLoadingState());
    final result = await repository.getAssignedCollectionRequests(status: event.status);
    result.fold(
      (error) => emit(CollectionRequestsWorkerErrorState(error)),
      (requests) => emit(CollectionRequestsWorkerLoadedState(
        requests: requests,
        activeTab: event.status ?? 'active',
      )),
    );
  }

  Future<void> _onUpdateCollectionRequestStatus(
    UpdateCollectionRequestStatusEvent event,
    Emitter<CollectionRequestsWorkerState> emit,
  ) async {
    emit(CollectionRequestsWorkerUpdatingState());
    final result = await repository.updateCollectionRequestStatus(
      event.requestId,
      event.status,
    );
    result.fold(
      (error) => emit(CollectionRequestsWorkerErrorState(error)),
      (updatedRequest) => emit(CollectionRequestsWorkerSuccessState(
        message: 'Status updated successfully',
        updatedRequest: updatedRequest,
      )),
    );
  }

  Future<void> _onSubmitGarbageWeights(
    SubmitGarbageWeightsEvent event,
    Emitter<CollectionRequestsWorkerState> emit,
  ) async {
    emit(CollectionRequestsWorkerUpdatingState());
    final result = await repository.submitGarbageWeights(
      event.requestId,
      event.weights,
    );
    result.fold(
      (error) => emit(CollectionRequestsWorkerErrorState(error)),
      (updatedRequest) => emit(CollectionRequestsWorkerSuccessState(
        message: 'Collection completed successfully',
        updatedRequest: updatedRequest,
      )),
    );
  }
}
