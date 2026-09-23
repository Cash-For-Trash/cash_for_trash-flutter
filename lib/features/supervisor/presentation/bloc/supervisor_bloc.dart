import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/supervisor_repository.dart';
import 'supervisor_event.dart';
import 'supervisor_state.dart';

class SupervisorBloc extends Bloc<SupervisorEvent, SupervisorState> {
  final SupervisorRepository repository;

  SupervisorBloc({required this.repository}) : super(const SupervisorState()) {
    on<GetSupervisorWorkersEvent>(_onGetSupervisorWorkers);
    on<FetchMoreSupervisorWorkersEvent>(_onFetchMoreSupervisorWorkers);
    on<SearchSupervisorWorkersEvent>(_onSearchSupervisorWorkers);
    on<CreateSupervisorWorkerEvent>(_onCreateSupervisorWorker);
  }

  Future<void> _onGetSupervisorWorkers(
    GetSupervisorWorkersEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(state.copyWith(
      workersStatus: SupervisorWorkersStatus.loading,
      workersErrorMessage: '',
      currentPage: 1,
      hasMorePages: false,
    ));

    final result = await repository.getSupervisorWorkers(page: 1, pageSize: 10);

    result.fold(
      (error) => emit(state.copyWith(
        workersStatus: SupervisorWorkersStatus.failure,
        workersErrorMessage: error,
      )),
      (response) {
        final hasMore = response.data.length < response.totalItems &&
            response.data.isNotEmpty;
        emit(state.copyWith(
          workersStatus: SupervisorWorkersStatus.success,
          workers: response.data,
          currentPage: 1,
          hasMorePages: hasMore,
          totalItems: response.totalItems,
        ));
      },
    );
  }

  Future<void> _onFetchMoreSupervisorWorkers(
    FetchMoreSupervisorWorkersEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    if (!state.hasMorePages || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await repository.getSupervisorWorkers(page: nextPage, pageSize: 10);

    result.fold(
      (error) => emit(state.copyWith(isLoadingMore: false)),
      (response) {
        final updatedList = List.of(state.workers)..addAll(response.data);
        final hasMore = updatedList.length < response.totalItems &&
            response.data.isNotEmpty;
        emit(state.copyWith(
          workers: updatedList,
          currentPage: nextPage,
          hasMorePages: hasMore,
          isLoadingMore: false,
          totalItems: response.totalItems,
        ));
      },
    );
  }

  void _onSearchSupervisorWorkers(
    SearchSupervisorWorkersEvent event,
    Emitter<SupervisorState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onCreateSupervisorWorker(
    CreateSupervisorWorkerEvent event,
    Emitter<SupervisorState> emit,
  ) async {
    emit(state.copyWith(
      createWorkerStatus: CreateWorkerStatus.loading,
      createWorkerErrorMessage: '',
    ));

    final result = await repository.createWorker(event.request);

    result.fold(
      (error) {
        emit(state.copyWith(
          createWorkerStatus: CreateWorkerStatus.failure,
          createWorkerErrorMessage: error,
        ));
      },
      (_) {
        emit(state.copyWith(
          createWorkerStatus: CreateWorkerStatus.success,
        ));
        add(const GetSupervisorWorkersEvent());
      },
    );
  }
}
