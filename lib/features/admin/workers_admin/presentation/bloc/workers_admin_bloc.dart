import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/workers_admin_repository.dart';
import 'workers_admin_event.dart';
import 'workers_admin_state.dart';

class WorkersAdminBloc extends Bloc<WorkersAdminEvent, WorkersAdminState> {
  final WorkersAdminRepository repository;

  WorkersAdminBloc({required this.repository})
    : super(WorkersAdminInitialState()) {
    on<GetWorkersAdminEvent>(_onGetWorkers);
    on<GetWorkerDetailAdminEvent>(_onGetWorkerDetail);
    on<ApproveWorkerAdminEvent>(_onApproveWorker);
  }

  Future<void> _onGetWorkers(
    GetWorkersAdminEvent event,
    Emitter<WorkersAdminState> emit,
  ) async {
    emit(WorkersAdminLoadingState());
    final result = await repository.getWorkers(
      page: event.page,
      pageSize: event.pageSize,
    );
    result.fold(
      (error) => emit(WorkersAdminErrorState(error)),
      (workers) => emit(WorkersAdminLoadedState(workers: workers)),
    );
  }

  Future<void> _onGetWorkerDetail(
    GetWorkerDetailAdminEvent event,
    Emitter<WorkersAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is WorkersAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    } else {
      emit(WorkersAdminLoadingState());
    }

    final result = await repository.getWorkerDetail(event.userId);
    result.fold((error) => emit(WorkersAdminErrorState(error)), (worker) {
      if (currentState is WorkersAdminLoadedState) {
        emit(
          currentState.copyWith(selectedWorker: worker, isActionLoading: false),
        );
      } else {
        emit(
          WorkersAdminLoadedState(workers: const [], selectedWorker: worker),
        );
      }
    });
  }

  Future<void> _onApproveWorker(
    ApproveWorkerAdminEvent event,
    Emitter<WorkersAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is WorkersAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
      final result = await repository.approveWorker(event.workerId);
      result.fold((error) => emit(WorkersAdminErrorState(error)), (msg) {
        emit(
          currentState.copyWith(isActionLoading: false, successMessage: msg),
        );
        // Refresh the list after approval
        add(const GetWorkersAdminEvent());
      });
    }
  }
}
