import 'package:equatable/equatable.dart';
import '../../data/model/worker_admin_model.dart';

abstract class WorkersAdminState extends Equatable {
  const WorkersAdminState();

  @override
  List<Object?> get props => [];
}

class WorkersAdminInitialState extends WorkersAdminState {}

class WorkersAdminLoadingState extends WorkersAdminState {}

class WorkersAdminLoadedState extends WorkersAdminState {
  final List<WorkerAdminModel> workers;
  final WorkerAdminModel? selectedWorker;
  final bool isActionLoading;
  final String? successMessage;

  const WorkersAdminLoadedState({
    required this.workers,
    this.selectedWorker,
    this.isActionLoading = false,
    this.successMessage,
  });

  WorkersAdminLoadedState copyWith({
    List<WorkerAdminModel>? workers,
    WorkerAdminModel? selectedWorker,
    bool? isActionLoading,
    String? successMessage,
  }) {
    return WorkersAdminLoadedState(
      workers: workers ?? this.workers,
      selectedWorker: selectedWorker ?? this.selectedWorker,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [workers, selectedWorker, isActionLoading, successMessage];
}

class WorkersAdminErrorState extends WorkersAdminState {
  final String errorMessage;

  const WorkersAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
