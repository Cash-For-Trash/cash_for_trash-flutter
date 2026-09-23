import 'package:equatable/equatable.dart';
import '../../data/model/worker_supervisor_model.dart';

enum SupervisorWorkersStatus { initial, loading, success, failure }
enum CreateWorkerStatus { initial, loading, success, failure }

class SupervisorState extends Equatable {
  final SupervisorWorkersStatus workersStatus;
  final List<WorkerSupervisorModel> workers;
  final String workersErrorMessage;
  final String searchQuery;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final int totalItems;
  final CreateWorkerStatus createWorkerStatus;
  final String createWorkerErrorMessage;

  const SupervisorState({
    this.workersStatus = SupervisorWorkersStatus.initial,
    this.workers = const [],
    this.workersErrorMessage = '',
    this.searchQuery = '',
    this.currentPage = 1,
    this.hasMorePages = false,
    this.isLoadingMore = false,
    this.totalItems = 0,
    this.createWorkerStatus = CreateWorkerStatus.initial,
    this.createWorkerErrorMessage = '',
  });

  List<WorkerSupervisorModel> get filteredWorkers {
    if (searchQuery.trim().isEmpty) return workers;
    final query = searchQuery.trim().toLowerCase();
    return workers.where((worker) {
      final fullNameMatch = worker.fullName.toLowerCase().contains(query);
      final emailMatch = worker.email.toLowerCase().contains(query);
      final mobileMatch = worker.mobile.toLowerCase().contains(query);
      final nationalIdMatch = worker.nationalId?.toLowerCase().contains(query) ?? false;
      return fullNameMatch || emailMatch || mobileMatch || nationalIdMatch;
    }).toList();
  }

  SupervisorState copyWith({
    SupervisorWorkersStatus? workersStatus,
    List<WorkerSupervisorModel>? workers,
    String? workersErrorMessage,
    String? searchQuery,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
    int? totalItems,
    CreateWorkerStatus? createWorkerStatus,
    String? createWorkerErrorMessage,
  }) {
    return SupervisorState(
      workersStatus: workersStatus ?? this.workersStatus,
      workers: workers ?? this.workers,
      workersErrorMessage: workersErrorMessage ?? this.workersErrorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalItems: totalItems ?? this.totalItems,
      createWorkerStatus: createWorkerStatus ?? this.createWorkerStatus,
      createWorkerErrorMessage: createWorkerErrorMessage ?? this.createWorkerErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        workersStatus,
        workers,
        workersErrorMessage,
        searchQuery,
        currentPage,
        hasMorePages,
        isLoadingMore,
        totalItems,
        createWorkerStatus,
        createWorkerErrorMessage,
      ];
}
